require "html_analyzer/version"
require "html_analyzer/html_page"

module HtmlAnalyzer

  def self.analyze url
    HtmlPage.process(url)
  end
end
