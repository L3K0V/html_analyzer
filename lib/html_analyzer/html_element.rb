module HtmlAnalyzer

  class HtmlElement
    attr_reader :type, :classes, :id, :depth, :links

    def initialize(element)
      @type = element.name
      @classes = element.attributes['class'].value.strip.split if element.attributes['class']
      @id = element.attributes['id'].value if element.attributes['id']
      @depth = element.ancestors.size
      @links = extract_links element
    end

    protected
    def extract_links element
      element.search('a')
             .reject { |e| e.text.strip.empty? }
             .collect { |e| HtmlAnalyzer::HtmlLink.new(e) }
    end
  end
end
