require 'spec_helper'

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://wildeisen.ch" do
  let(:webpage) { HtmlAnalyzer.analyze('https://wildeisen.ch/') }
  let(:footers) { webpage.footers }

  it "has 1 footer found" do
    expect(footers.length).to be 1
  end

  context "#extract_links" do
    it "has a 52 entries on the first navigation" do # We need to filter extracting of all <a> based on criteria
      expect(footers.first.extract_links.length).to be 52
    end
  end
end

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://youtube.com" do
  let(:webpage) { HtmlAnalyzer.analyze('https://youtube.com') }
  let(:footers) { webpage.footers }

  it "has 1 footer found" do
    expect(footers.length).to be 1
  end

  context "#extract_links" do
    it "has a 13 entries on the first navigation" do # We need to filter extracting of all <a> based on criteria
      expect(footers.first.extract_links.length).to be 13
    end
  end
end
