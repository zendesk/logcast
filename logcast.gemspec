require_relative 'lib/logcast/version'

Gem::Specification.new do |s|
  s.name        = "logcast"
  s.version     = Logcast::VERSION
  s.authors     = ["Steven Davidovitz", "Michael Grosser"]
  s.email       = ["support@zendesk.com"]
  s.homepage    = "https://github.com/zendesk/logcast"
  s.summary     = %q{Log Broadcaster}
  s.description = %q{Broadcasts logs, including support for Rails version 4.2.}
  s.license = 'Apache License Version 2.0'

  s.required_ruby_version     = ">= 2.5.0"

  s.add_dependency "activesupport"

  s.files              = Dir["lib/**/*.rb"]
  s.require_paths      = ["lib"]
end
