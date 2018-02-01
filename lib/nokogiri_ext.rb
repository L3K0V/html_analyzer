module Nokogiri

  PATTERNS = {

    :header => [
        'header', "[role='banner']"
    ],

    :footer => [
      'footer', "[role='contentinfo']",
      '//div[starts-with(@class, "footer")]', '//div[starts-with(@id, "footer")]'
    ],

    :navigation => [
      'nav', "[role='navigation']",
      '//div[starts-with(@class, "nav")]', '//div[starts-with(@id, "nav")]',
      '//div[starts-with(@class, "navigation")]', '//div[starts-with(@id, "navigation")]'
    ]
  }

  module Regionable
    def search_header
      self.search(*PATTERNS[:header])
    end

    def search_navigation
      self.search(*PATTERNS[:navigation])
    end

    def search_footer
      self.search(*PATTERNS[:footer])
    end
  end

  module XML
    class Element
      include Nokogiri::Regionable
    end
  end

  module HTML
    class Document
      include Nokogiri::Regionable
    end
  end
end
