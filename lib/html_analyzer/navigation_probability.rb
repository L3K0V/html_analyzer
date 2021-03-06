module HtmlAnalyzer
  module NavigationProbability
    public

    def is_element?
      calc_probability >= 0.5
    end

    def get_probability
      calc_probability
    end

    def get_model
      calc_model
    end

    private

    NAV_LITERALS = %w[nav navigation].freeze
    OTHER_LITERALS = %w[menu main].freeze

    def calc_probability
      coef = 0.0
      coef += 0.35 if @tag == 'nav'
      coef += 0.15 if @tag == 'div'
      coef += 0.75 if @role == 'navigation'
      coef += 0.10 if links?
      coef += 0.15 if links? && links.size / 2 <= links_by_depth.first[1]

      home = links.select do |link|
        link.url == '/'
      end

      coef += 0.35 if home.any?

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
    def calc_model
      tag_c = 0

      tag_c = case @tag
              when 'nav'
                3
              when 'div'
                2
              when 'header'
                1
              when 'footer'
                -1
              else
                0
              end

      nav_literals = %w[nav navigation]
      other_literals = %w[menu main appbar topbar]
      footer_literals = %w[bottom footer]
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

      clss_count = 0
      clss_count = @classes.length if @classes

      role_c = 0
      role_c = @role == 'navigation' ? 3 : 0 if @role
      role_c = @role == 'menu' ? 2 : role_c if @role
      role_c = @role == 'menubar' ? 2 : role_c if @role
      role_c = @role == 'toolbar' ? 1 : role_c if @role
      role_c = @role == 'contentinfo' ? -1 : role_c if @role

      id_c = 0
      id_c = @id.downcase.match(Regexp.union(NAV_LITERALS)) ? 2 : 0 if @id
      id_c = @id.downcase.match(Regexp.union(OTHER_LITERALS)) ? 1 : id_c if @id
      id_c = @id.downcase.match(Regexp.union(footer_literals)) ? -1 : id_c if @id

      links_s = 0
      links_depth = 0

      contains_link_to_home = links.select do |link|
        link.url == '/'
      end

      links_s = 1 if links?
      links_depth = 1 if links? && links.size / 2 <= links_by_depth.first[1]

      "#{tag_c},#{clss_c},#{clss_count},#{id_c},#{role_c},#{contains_link_to_home.any? ? 1 : 0},#{depth},#{links_s},#{links_depth}"
    end
  end
end
