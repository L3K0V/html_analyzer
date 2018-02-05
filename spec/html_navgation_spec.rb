require 'spec_helper'
require 'pp'

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://wildeisen.ch" do
  let(:webpage) { HtmlAnalyzer.analyze('https://wildeisen.ch/') }
  let(:navigation) { webpage.navigation }

  it "has navigations" do
    expect(navigation).to be
  end

  it "has probability equal or more than 0.6" do
    expect(navigation.probability).to be >= 0.6
  end

  context "#extract_links" do
    it "has a 6 entries on the main navigation" do
      expect(navigation.links.length).to be 6
    end
  end
end
