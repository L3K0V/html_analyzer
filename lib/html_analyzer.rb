require "html_analyzer/version"
require "html_analyzer/html_element"
require "html_analyzer/html_link"
require "html_analyzer/html_page"
require "html_analyzer/html_header"
require "html_analyzer/html_navigation"
require "html_analyzer/html_footer"

module HtmlAnalyzer

  require "nokogiri"
  require_relative "nokogiri_ext"
  require "open-uri"

  def self.analyze url
    HtmlPage.process(url)
  end
end
