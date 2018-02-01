module HtmlAnalyzer

  class HtmlHeader < HtmlElement
    attr_reader :navigations

    def initialize(element)
      super(element)
      elements = element.search_navigation
      @navigations = elements.collect { |el| HtmlNavigation.new(el) }
    end

    def navigation?
      @navigations.any?
    end
  end
end
