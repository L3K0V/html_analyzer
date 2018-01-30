require 'spec_helper'

RSpec.describe HtmlAnalyzer do
  context "#header?" do
    it "can detect header using <header> tag in the web page" do
      page = HtmlAnalyzer.analyze('https://wildeisen.ch/')
      expect(page.header?).to be
    end

    it "can detect header using role attribute 'banner' in a web page without a <header>" do
      page = HtmlAnalyzer.analyze('https://wikipedia.org/wiki/Main_Page')
      expect(page.header?).to be
    end

    it "can detect that the web page doesn't have any header or element with role 'banner'" do
      page = HtmlAnalyzer.analyze('https://google.com')
      expect(page.header?).to be_falsey
    end
  end

  context "#navigation?" do
    it "can detect navigation using a 'nav' tag in a webpage with a <nav>" do
      page = HtmlAnalyzer.analyze('https://wildeisen.ch/')
      expect(page.navigation?).to be
    end

    it "can detect navigation using role attribute eq 'navigation' in webpage without a <nav>" do
      page = HtmlAnalyzer.analyze('https://youtube.com/')
      expect(page.navigation?).to be
    end
  end

  context "#footer" do
    it "can detect footer using <footer> tag in the web page" do
      page = HtmlAnalyzer.analyze('https://wildeisen.ch/')
      expect(page.footer?).to be
    end
  end

  context "#main" do
    it "can detect main using id main*" do
      page = HtmlAnalyzer.analyze('http://www.telezueri.ch/')
      expect(page.main?).to be
    end
  end
end
