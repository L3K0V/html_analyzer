module HtmlAnalyzer
  class HtmlSpider
    REQUEST_INTERVAL = 5
    MAX_URLS = 1000

    def initialize(options = {})
      @urls     = []
      @results  = []

      @interval = options.fetch(:interval, REQUEST_INTERVAL)
      @max_urls = options.fetch(:max_urls, MAX_URLS)
    end

    def enqueue(url)
      @urls << url
    end

    def record(data = {})
      @results << data
    end

    def results
      return enum_for(:results) unless block_given?

      i = @results.length
      enqueued_urls.each do |url|
        begin
          log "Handling", url.inspect

          page = HtmlPage.process(url)

          data = {
            "url" => url,
            "elements" => [
              {
                "element" => page.navigation&.get_model,
                "probability" => page.navigation&.get_probability
              },
              {
                "element" => page.header&.get_model,
                "probability" => page.header&.get_probability
              },
              {
                "element" => page.footer&.get_model,
                "probability" => page.footer&.get_probability
              }
            ]
          }

          page.document.search('div', 'main', 'footer', 'nav').each do |node|
            element = HtmlElement.new(node)
            data["elements"].push({
                "element" => element.get_model,
                "probability" => element.get_probability
            })
          end

          self.record data

          if block_given? && @results.length > i
            yield @results.last
            i += 1
          end
        rescue => ex
          log "Error", "#{url.inspect}, #{ex}"
        end
        sleep @interval if @interval > 0
      end
    end

    def enqueued_urls
      Enumerator.new do |y|
        index = 0
        while index < @urls.count && index <= @max_urls
          url = @urls[index]
          index += 1
          next unless url
          y.yield url
        end
      end
    end

    private
    def log(label, info)
      warn "%-10s: %s" % [label, info]
    end
  end
end
