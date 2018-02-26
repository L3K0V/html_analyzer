module HtmlAnalyzer

  class HtmlHeader < HtmlElement
    attr_reader :navigations

    def initialize(element)
      super(element)
      elements = element.search_navigation
                          .reject {|e| e.attributes['class'].value.include? 'footer' if e.attributes['class']}
                          .sort_by { |e| e.ancestors.size}
      @navigations = elements.collect { |el| HtmlNavigation.new(el) } if elements.any?
    end

    def navigation?
      @navigations.any?
    end
  end
end
