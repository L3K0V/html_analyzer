require 'spec_helper'

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://wildeisen.ch" do
  let(:webpage) { HtmlAnalyzer.analyze('https://wildeisen.ch/') }
  let(:footer) { webpage.footer }

  it "has a footer" do
    expect(footer).to be
  end

  context "#extract_links" do
    it "has a 51 entries on the footer" do # We need to filter extracting of all <a> based on criteria
      expect(footer.links.length).to be 51
    end
  end
end

RSpec.describe HtmlAnalyzer::HtmlNavigation, "using https://youtube.com" do
  let(:webpage) { HtmlAnalyzer.analyze('https://youtube.com') }
  let(:footer) { webpage.footer }

  it "has 1 footer found" do
    expect(footer).to be
  end

  context "#extract_links" do
    it "has a 13 entries on the footer" do # We need to filter extracting of all <a> based on criteria
      expect(footer.links.length).to be 13
    end
  end
end
