module HtmlAnalyzer
  class HtmlPage

    attr_reader :navigations

    def initialize(url)
      @document = Nokogiri::HTML(
        open(url, "Accept-Language" => "en-US")
      )

      @navigations = @document.css('nav', "[role='navigation']").collect { |element| HtmlNavigation.new(element) }

      process_footer
    end

    def self.process(url)
      self.new(url)
    end

    def footer?
      @footers.any?
    end

    def header?
      @document.css('header', "[role='banner']").any?
    end

    def main?
      @document.css('main', "[role='main']").any?
    end

    def navigation?
      @navigations.any?
    end

    def footers
      @footers
    end

    private
    def process_footer
      elements = @document.css('footer', "[role='contentinfo']", "div#footer")
      @footers = elements.reject { |element| element.ancestors.size > 10}
                         .collect { |element| HtmlFooter.new(element)}
    end
  end
end
