# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tugg_api/version'

Gem::Specification.new do |spec|
  spec.name          = "tugg_api"
  spec.version       = TuggApi::VERSION
  spec.authors       = ["Luke Wendling"]
  spec.email         = ["luke@lukewendling.com"]
  spec.description   = %q{Interact with the Tugg API via Ruby's EventMachine}
  spec.summary       = %q{Access the Tugg API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "em-http-request", "~> 1.1.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rb-readline"
end
