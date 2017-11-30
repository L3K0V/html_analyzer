module HtmlAnalyzer

  require "nokogiri"
  require "open-uri"

  class HtmlPage

    ##
    # Initialize HtmlPage with given URL
    #
    def initialize(url)
      @document = Nokogiri::HTML(
        open(url, "Accept-Language" => "en-US")
      )
    end

    def self.process(url)
      self.new(url)
    end

    ##
    # Check what ever the HTML page contains a footer
    #
    # @return [true] whenever when the HTML page have footer
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
      @document.css('nav', "[role='navigation']").any?
    end

    def navigation
      @document.css('nav', "[role='navigation']")
    end

    def extract_links from
      Hash[from.css('a').map { |link| [link.text.strip, link["href"]] }]
    end
  end
end
