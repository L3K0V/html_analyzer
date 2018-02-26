require 'spec_helper'
require 'pp'

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://wildeisen.ch" do
  let(:webpage) { HtmlAnalyzer.analyze('https://wildeisen.ch/') }
  let(:navigation) { webpage.navigation }

  it "has navigations" do
    expect(navigation).to be
  end

  it "has probability equal or more than 0.6" do
    expect(navigation.is_element?).to be
  end

  context "#extract_links" do
    it "has a 6 entries on the main navigation" do
      expect(navigation.links.length).to be 6
    end
  end

  context "#navigation_in_header" do
    it "expect navigation to be recognized in the site header" do
      expect(webpage.navigation_in_header?).to be
    end
  end
end

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://www.culturata.com/" do
  let(:webpage) { HtmlAnalyzer.analyze('https://www.culturata.com/') }
  let(:navigation) { webpage.navigation }

  it "has navigations" do
    expect(navigation).to be
  end

  it "has positive navigation_probability" do
    expect(navigation.is_element?).to be
  end

  context "#navigation_in_header" do
    it "expect navigation to be recognized in the site header" do
      expect(webpage.navigation_in_header?).to be
    end
  end
end
