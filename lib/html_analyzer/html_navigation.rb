module HtmlAnalyzer

  require_relative "with_links"

  class HtmlNavigation < HtmlElement
    include WithLinks
  end

end