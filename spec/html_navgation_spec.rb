require 'spec_helper'

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://wildeisen.ch" do
  let(:webpage) { HtmlAnalyzer.analyze('https://wildeisen.ch/') }
  let(:navigations) { webpage.navigations }

  context "#extract_links" do
    it "has 3 navigations found" do
      expect(navigations.length).to be 3
    end

    it "has a 3 entries on the first navigation" do
      expect(navigations.first.extract_links.length).to be 6
    end
  end
end
