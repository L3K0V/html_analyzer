module HtmlAnalyzer

  class HtmlElement
    attr_reader :type, :classes, :id, :role, :depth, :links

    def initialize(element)
      @type = element.name
      @classes = element.attributes['class'].value.strip.split if element.attributes['class']
      @id = element.attributes['id'].value if element.attributes['id']
      @role = element.attributes['role'].value if element.attributes['role']
      @depth = element.ancestors.size
      @links = extract_links element
    end

    def id?
      !@id.nil?
    end

    def role?
      !@role.nil?
    end

    def links?
      @links.any?
    end

    def links_by_depth
      @links.each_with_object(Hash.new(0)) { |link, counts| counts[link.depth] += 1 }.sort_by {|k, v| v}.reverse
    end

    def probability
      coef = 0.0
      coef += 0.35 if @type == 'nav'
      coef += 0.15 if @type == 'div'
      coef += 0.75 if @role == 'navigation'
      coef += 0.10 if self.links?
      coef += 0.15 if self.links? && self.links.size / 2 <= self.links_by_depth.first[1]

      if @classes
        @classes.each do |clss|
          if clss.downcase.match(Regexp.union(NAV_LITERALS))
            coef += 0.45
            break
          end

          if clss.downcase.match(Regexp.union(OTHER_LITERALS))
            coef += 0.10
            break
          end
        end
      end

      coef
    end

    protected
    def extract_links element
      element.search('a')
             .reject { |e| e.text.strip.empty? }
             .collect { |e| HtmlAnalyzer::HtmlLink.new(e) }
    end

    private
    NAV_LITERALS = ["nav", "navigation"]
    OTHER_LITERALS = ["menu", "main"]
  end
end
