module HtmlAnalyzer

  require_relative "with_links"

  class HtmlHeader < HtmlElement
    include WithLinks

    attr_reader :navigations

    def initialize(element)
      super(element)
      process_navigation
    end

    def navigation?
      @navigations.any?
    end

    private
    def process_navigation
      elements = @element.search_navigation
      @navigations = elements.collect { |el| HtmlNavigation.new(el) }
    end

  end
end
