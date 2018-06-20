# HtmlAnalyzer

This gem provides a simple way to identify elements on a web page such a header, navigation and footer also modifying webpages on the fly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'html_analyzer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html_analyzer

## Usage

### Analyse html
Analysing HTML provides information about the structure of the webpage.
For example you can obtain if page contains header, footer of has navigation.
You can extract links from these components if exists.

In order to check some page if contains header, you can:

```ruby
page = HtmlAnalyzer.analyze('https://github.com/')

page.header?
=> true
page.header.get_probability
=> 0.4

# You can check if header contains a navigation

page.header.navigation?
=> true

page.navigation_in_header?
=> true

# The difference between two methods are that navigation_in_header will return true
# if main navigation is in the header. Header can contains some context navigation.

# Also there is way to determine if page have a footer

page.footer?
=> true
page.footer.get_probability
=> 0.4

# Checking if there is a navigation, presume this will find the main navigation

page.navigation?
=> true
page.navigation.get_probability
=> 0.6
```

You can get the element if exist by calling

```ruby
page.header
# or the footer
page.footer
# or the navigation
page.navigation
```

> Notice that probability is the probability element to be a main navigation element.

### Modify html
Currently the gem support a way to return a modified version of the webpage HTML
*excluding* the footer, header and the navigation.

```ruby
HtmlAnalyzer.modify('https://github.com/')
```

#### Post-processing

Modify method provide way to post-process the document before return of the HTML of the page.
You can access and modify the document passing a block and do whatever you want as a post process.

```ruby
page = HtmlAnalyzer.modify('http://mobil.mopo.de/', user_agent = HtmlAnalyzer::PHONE_USER_AGENT) do |document|
  content = document.search("//div[@class='offcanvas-pagecontent']").first
  content['style'] = 'margin-left: 0%'
end
```

### User agent

User can specify how the analyzer tool to behave - as desktop or phone. This can be passed to the `HtmlAnalyzer` methods as a second argument

```ruby
# by default HtmlAnalyzer will analyze as dekstop
page = HtmlAnalyzer.analyze('https://github.com/', HtmlAnalyzer::DESKTOP_USER_AGENT)
html = HtmlAnalyzer.modify('https://github.com/', HtmlAnalyzer::DESKTOP_USER_AGENT)

# or analyze/process as phone
page = HtmlAnalyzer.analyze('https://github.com/', HtmlAnalyzer::PHONE_USER_AGENT)
html = HtmlAnalyzer.modify('https://github.com/', HtmlAnalyzer::PHONE_USER_AGENT)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/L3K0V/html_analyzer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HtmlAnalyzer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/L3K0V/html_analyzer/blob/master/CODE_OF_CONDUCT.md).
