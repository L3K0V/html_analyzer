require "html_analyzer/version"
require "html_analyzer/html_page"
require "html_analyzer/html_navigation"

module HtmlAnalyzer

  require "nokogiri"
  require "open-uri"

  def self.analyze url
    HtmlPage.process(url)
  end
end
