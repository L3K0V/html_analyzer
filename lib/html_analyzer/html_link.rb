module HtmlAnalyzer

  class HtmlLink < HtmlElement
    attr_reader :title, :url, :target

    def initialize(element)
      super(element)

      @title = element.text.strip
      @url = element['href']
      @target = element['target']
    end
  end

end
