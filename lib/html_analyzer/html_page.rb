module HtmlAnalyzer
  class HtmlPage

    attr_reader :navigation
    attr_reader :footer

    def initialize(url)
      @uri = URI.parse(url)
      @document = Nokogiri::HTML(
        open(url, "Accept-Language" => "en-US")
      )

      strip_page

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
      @document.css('header', "[role='banner']").any?
    end

    def main?
      @document.search('main', "[role='main']", '//div[starts-with(@class, "main")]').any?
    end

    private
    def process_footer

      patterns = [
        'footer', "[role='contentinfo']",
        '//div[starts-with(@class, "footer")]', '//div[starts-with(@id, "footer")]'
      ]

      elements = @document.search(*patterns).sort_by { |e| e.ancestors.size }
      @footer = HtmlFooter.new(elements.first)
    end

    def process_navigation

      patterns = [
        'nav', "[role='navigation']",
        '//div[starts-with(@class, "nav")]', '//div[starts-with(@id, "nav")]'
      ]

      elements = @document.search(*patterns)
                          .reject {|e| e.attributes['class'].value.include? 'footer' if e.attributes['class']}
                          .sort_by { |e| e.ancestors.size}

      @navigation = HtmlNavigation.new(elements.first)
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
