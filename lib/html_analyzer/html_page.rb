module HtmlAnalyzer
  class HtmlPage
    attr_reader :header, :navigation, :footer, :document, :uri

    def initialize(url, user_agent = HtmlAnalyzer::PHONE_USER_AGENT)
      @uri = URI.parse(url)
      @document = Nokogiri::HTML(
        open(url, 'Accept-Language' => 'en-US', 'User-Agent' => user_agent)
      )

      @elements = @document.search('div', 'main', 'footer', 'nav').collect { |el| HtmlElement.new(el) }

      # strip_page

      process_header
      process_navigation
      process_footer
    end

    def self.modify(url, user_agent)
      page = new(url, user_agent)

      navigation = page.document.search_navigation
                       .reject { |e| e.attributes['class'].value.include? 'footer' if e.attributes['class'] }
                       .reject { |e| e.attributes['class'].value.include? 'shifter' if e.attributes['class'] }
                       .sort_by { |e| e.ancestors.size }
      navigation.first.remove if navigation.any?

      header = page.document.css('header', "[role='banner']")
                   .reject { |e| e.attributes['class'].value.include? 'section' if e.attributes['class'] }
                   .sort_by { |e| e.ancestors.size }

      if header.any?
        header.first.ancestors.each do |el|
          next unless el.element?

          if el.attributes['class'] && el.attributes['class'].value.downcase.include?('nav')
            el.remove
            break
          end
        end

        header.first.remove
      end

      footer = page.document.search_footer.sort_by { |e| e.ancestors.size }
      footer.first.remove if footer.any?

      # page.fix_relative_urls

      page.document.to_html
    end

    def self.process(url, user_agent)
      new(url, user_agent)
    end

    def footer?
      !@footer.nil?
    end

    def navigation?
      !@navigation.nil?
    end

    def header?
      !@header.nil?
    end

    def main?
      @document.search('main', "[role='main']", '//div[starts-with(@class, "main")]').any?
    end

    def navigation_in_header?
      persist = header? && navigation? && header.navigation?

      if persist
        persist &&= header.navigations.select do |nav|
          navigation.get_model == nav.get_model
        end.any?
      end

      persist
    end

    def fix_relative_urls
      @document.search('//link/@href').each do |link|
        # We don't want to fix custom schemes like mailto: fb: etc...
        next unless link.value.start_with? 'http'

        begin
          uri = URI.parse(link.value)
        rescue StandardError
          next
        end

        # Absolute paths are okay, so we skip them...
        next unless uri.relative?
        uri.scheme = @uri.scheme
        uri.host = @uri.host
        link.value = uri.to_s
      end

      tags = {
        'img'    => 'src',
        'script' => 'src',
        'a'      => 'href'
      }

      @document.search(tags.keys.join(',')).each do |node|
        url_param = tags[node.name]

        src = node[url_param]

        next if src.nil? || src.empty?
        # We don't want to fix custom schemes like mailto: fb: etc...
        next unless src.start_with? 'http'

        begin
          uri = URI.parse(src.strip)
        rescue StandardError
          next
        end

        # Absolute paths are okay, so we skip them...
        next unless uri.relative?
        uri.scheme = @uri.scheme
        uri.host = @uri.host
        node[url_param] = uri.to_s
      end
    end

    private

    def process_header
      elements = @document.css('header', "[role='banner']")
      @header = HtmlHeader.new(elements.first) if elements.any?
    end

    def process_navigation
      # Seach elements with given patterns but reject these who class incude footer.
      # This way if there are more outer <nav> tag with a footer class will be exluded
      # Also we reject navs with shifter class because this is injected by jquery mobile nav.
      # We do not want to be confused by duplicated navs.
      elements = @document.search_navigation
                          .reject { |e| e.attributes['class'].value.include? 'footer' if e.attributes['class'] }
                          .reject { |e| e.attributes['class'].value.include? 'shifter' if e.attributes['class'] }
                          .sort_by { |e| e.ancestors.size }

      @navigation = HtmlNavigation.new(elements.first) if elements.any?
    end

    def process_footer
      elements = @document.search_footer.sort_by { |e| e.ancestors.size }
      @footer = HtmlFooter.new(elements.first) if elements.any?
    end

    def strip_page
      for_removal = [
        'article', 'aside', 'audio',
        'blockquote', 'br',
        'canvas', 'code', '//comment()',
        'figure', 'form', 'iframe',
        'picture', 'textarea', 'script', 'noscript', 'img', 'p', 'table'
      ]

      @document.search(*for_removal).each(&:remove)

      directory_name = 'tmp'
      Dir.mkdir(directory_name) unless File.exist?(directory_name)

      File.open("#{directory_name}/#{name}.html", 'w') do |f|
        f.write(@document.to_html)
      end
    end

    def name
      host = @uri.host
      name = host.start_with?('www.') ? host[4..-1] : host
      name = name.split('.')[0]
      name
    end
  end
end
