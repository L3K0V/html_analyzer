require 'html_analyzer/version'
require 'html_analyzer/html_element'
require 'html_analyzer/html_link'
require 'html_analyzer/html_page'
require 'html_analyzer/html_header'
require 'html_analyzer/html_navigation'
require 'html_analyzer/html_footer'
require 'html_analyzer/html_spider'

module HtmlAnalyzer
  require 'nokogiri'
  require_relative 'nokogiri_ext'
  require 'open-uri'

  PHONE_USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1'.freeze
  DESKTOP_USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'.freeze

  def self.analyze(url, user_agent = DESKTOP_USER_AGENT)
    HtmlPage.process(url, user_agent)
  end

  def self.modify(url, user_agent = DESKTOP_USER_AGENT)
    HtmlPage.modify(url, user_agent)
  end

  def self.gather
    HtmlSpider.new
  end
end
