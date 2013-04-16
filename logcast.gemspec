Gem::Specification.new do |s|
  s.name        = "logcast"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steven Davidovitz", "Michael Grosser"]
  s.email       = ["support@zendesk.com"]
  s.homepage    = "http://developer.zendesk.com"
  s.summary     = %q{Log Broadcaster}
  s.description = %q{Broadcasts logs, including support for Rails version 2.3 through 3.2.}
  s.license = 'Apache License Version 2.0'

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rake"

  s.files              = `git ls-files -x Gemfile.lock`.split("\n") rescue ''
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end
