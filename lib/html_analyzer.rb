require "html_analyzer/version"

require "nokogiri"
require "open-uri"

module HtmlAnalyzer

  def self.analyze url
    doc = Nokogiri::HTML(open(url))
  end
end
