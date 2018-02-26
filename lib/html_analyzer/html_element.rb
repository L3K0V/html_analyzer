module HtmlAnalyzer

  class HtmlElement
    require_relative "element_probability"
    include HtmlAnalyzer::ElementProbability

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

    def to_s
      "#{tag} #{id} #{classes} #{role}"
    end

    protected
    def extract_links element
      element.search('a')
             .reject { |e| e.text.strip.empty? }
             .collect { |e| HtmlAnalyzer::HtmlLink.new(e) }
    end
  end
end
