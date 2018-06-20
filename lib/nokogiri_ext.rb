module Nokogiri
  PATTERNS = {

    header: [
      'header', "[role='banner']",
      '//div[contains(@class, "header")]', '//div[contains(@id, "header")]',
      '//div[contains(@class, "topbar")]', '//div[contains(@id, "topbar")]',
      '//div[contains(@class, "appbar")]', '//div[contains(@id, "appbar")]'
    ],

    footer: [
      'footer', "[role='contentinfo']",
      '//div[contains(@class, "footer")]', '//div[contains(@id, "footer")]'
    ],

    navigation: [
      'nav', "[role='navigation']",
      '//div[contains(@class, "nav")]', '//div[contains(@id, "nav")]',
      '//div[contains(@class, "navigation")]', '//div[contains(@id, "navigation")]',
      '//div[contains(@class, "navbar")]', '//div[contains(@id, "navbar")]'
    ]
  }.freeze

  module Regionable
    def search_header
      search(*PATTERNS[:header])
    end

    def search_navigation
      search(*PATTERNS[:navigation])
    end

    def search_footer
      search(*PATTERNS[:footer])
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
