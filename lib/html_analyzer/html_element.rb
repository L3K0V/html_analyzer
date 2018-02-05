module HtmlAnalyzer

  class HtmlElement
    attr_reader :tag, :classes, :id, :role, :depth, :links

    def initialize(element)
      @tag = element.name
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
      coef += 0.35 if @tag == 'nav'
      coef += 0.15 if @tag == 'div'
      coef += 0.75 if @role == 'navigation'
      coef += 0.10 if self.links?
      coef += 0.15 if self.links? && self.links.size / 2 <= self.links_by_depth.first[1]

      coef += 0.20 if @id && @id.downcase.match(Regexp.union(NAV_LITERALS))
      coef += 0.10 if @id && @id.downcase.match(Regexp.union(OTHER_LITERALS))

      if @classes
        @classes.each do |clss|
          if clss.downcase.match(Regexp.union(NAV_LITERALS))
            coef += 0.45
            break
          end

          if clss.downcase.match(Regexp.union(OTHER_LITERALS))
            coef += 0.20
            break
          end
        end
      end

      coef
    end

    # Returns a linear model of the element for
    # linear regression analysis to tell if
    # this current element is a navigation of the webpage.
    def linear_model
      tag_c = 0

      case @tag
      when "nav"
        tag_c = 3
      when "div"
        tag_c = 2
      when "header"
        tag_c = 1
      when "footer"
        tag_c = -1
      else
        tag_c = 0
      end

      nav_literals = ["nav", "navigation"]
      other_literals = ["menu", "main"]
      footer_literals = ["bottom", "footer"]
      clss_c = 0

      if @classes
        @classes.each do |clss|
          if clss.downcase.match(Regexp.union(nav_literals))
            clss_c = 2
            break
          end

          if clss.downcase.match(Regexp.union(other_literals))
            clss_c = 1
            break
          end

          if clss.downcase.match(Regexp.union(footer_literals))
            clss_c = -1
            break
          end
        end
      end

      role_c = 0
      role_c = @role == "navigation" ? 1 : 0 if @role

      id_c = 0
      id_c = @id.downcase.match(Regexp.union(NAV_LITERALS)) ? 2 : 0 if @id
      id_c = @id.downcase.match(Regexp.union(OTHER_LITERALS)) ? 1 : id_c if @id
      id_c = @id.downcase.match(Regexp.union(footer_literals)) ? -1 : id_c if @id


      "#{tag_c},#{clss_c},#{role_c},#{depth},#{links.size},#{self.links_by_depth.first[1]}"
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
