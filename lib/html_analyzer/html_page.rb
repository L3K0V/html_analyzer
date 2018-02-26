module HtmlAnalyzer
  class HtmlPage

    attr_reader :header
    attr_reader :navigation
    attr_reader :footer
    attr_reader :elements

    def initialize(url)
      @uri = URI.parse(url)
      @document = Nokogiri::HTML(
        open(url, "Accept-Language" => "en-US")
      )

      @elements = @document.search('div', 'main', 'footer', 'nav').collect { |el| HtmlElement.new(el) }

      strip_page

      process_header
      process_navigation
      process_footer
    end

    def self.process(url)
      self.new(url)
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
      persist = self.header? && self.navigation? && self.header.navigation?

      if persist
        persist = persist && self.header.navigations.select { |nav|
          self.navigation.get_model == nav.get_model
        }.any?
      end

      persist
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
                          .reject {|e| e.attributes['class'].value.include? 'footer' if e.attributes['class']}
                          .reject {|e| e.attributes['class'].value.include? 'shifter' if e.attributes['class']}
                          .sort_by { |e| e.ancestors.size}

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

      @document.search(*for_removal).each { |node| node.remove }

      directory_name = "tmp"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      File.open("#{directory_name}/#{name}.html", "w") do |f|
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
