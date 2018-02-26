require 'spec_helper'
require 'pp'

RSpec.describe HtmlAnalyzer::HtmlHeader, "using https://www.telezueri.ch/" do
  let(:webpage) { HtmlAnalyzer.analyze('https://www.telezueri.ch/') }
  let(:header) { webpage.header }
  let(:navigation) { header.navigations.first }

  it "has header" do
    expect(header).to be
  end

  it "has navigation in header" do
    expect(header.navigation?).to be
  end

  it "has only one navigation in header" do
    expect(header.navigations.size).to be 1
  end

  it "navigation has probability equal or more than 0.6" do
    expect(header.navigations.first.is_element?).to be
  end

  context "#extract_links" do
    it "has a 4 entries on the header navigation" do
      expect(navigation.links.length).to be 4
    end
  end
end

RSpec.describe HtmlAnalyzer::HtmlHeader, "using https://stackoverflow.com/" do
  let(:webpage) { HtmlAnalyzer.analyze('https://stackoverflow.com/') }
  let(:header) { webpage.header }
  let(:navigation) { header.navigations.first }

  it "has header" do
    expect(header).to be
  end

  it "has navigation in header" do
    expect(header.navigation?).to be
  end

  it "has only 2 navigations in header" do
    expect(header.navigations.size).to be 2
  end

  it "navigations has probability equal or more than 0.6" do
    expect(header.navigations.first.is_element?).to be
    expect(header.navigations.last.is_element?).to be
  end

  context "#extract_links" do
    it "has a 4 entries on the first header navigation" do
      expect(navigation.links.length).to be 4
    end
  end
end
