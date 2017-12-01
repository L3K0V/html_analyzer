module HtmlAnalyzer
  class HtmlNavigation

    class Item

      attr_reader :title, :url, :target

      def initialize(element)
        @title = element.text.strip
        @url = element['href']
        @target = element['target']
      end
    end

    NONE    = 0
    BY_TAG  = 1
    BY_ARIA = 2

    attr_reader :recognized_by
    attr_reader :element

    def initialize(element)
      @element = element
      @recognized_by = element.name == 'nav' ? BY_TAG : BY_ARIA
    end

    def extract_links
      Hash[@element.css('a')
        .select { |link| !link.text.strip.empty? }
        .map { |link| [link.text.strip, Item.new(link)] }
      ]
    end
  end
end
