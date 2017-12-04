module WithLinks
  class Link
    attr_reader :title, :url, :target

    def initialize(element)
      @title = element.text.strip
      @url = element['href']
      @target = element['target']
    end
  end

  def extract_links
    Hash[self.element.css('a')
      .select { |link| !link.text.strip.empty? }
      .map { |link| [link.text.strip, Link.new(link)] }
    ]
  end
end
