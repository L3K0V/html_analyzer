module HtmlAnalyzer

  require_relative "with_links"

  class HtmlFooter < HtmlElement
    include WithLinks
  end

end
