
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "html_analyzer/version"

Gem::Specification.new do |spec|
  spec.name          = "html_analyzer"
  spec.version       = HtmlAnalyzer::VERSION
  spec.authors       = ["Asen Lekov"]
  spec.email         = ["asenlekoff@gmail.com"]

  spec.summary       = %q{Analyze HTML components and extract them.}
  spec.description   = %q{Analyze HTML components like header, navigation footer and return structured object for these components.}
  spec.homepage      = "https://github.com/L3K0V/html_analyzer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "nokogiri", "~> 1.8"
  spec.add_runtime_dependency "open_uri_redirections"
end
