module HtmlAnalyzer
  class HtmlPage

    attr_reader :navigations

    def initialize(url)
      @document = Nokogiri::HTML(
        open(url, "Accept-Language" => "en-US")
      )

      elements = @document.css('nav', "[role='navigation']")
      @navigations = elements.collect { |element| HtmlNavigation.new(element) }
    end

    def self.process(url)
      self.new(url)
    end

    def footer?
      @document.css('footer', "[role='complementary']").any?
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
  end
end
