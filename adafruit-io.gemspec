# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adafruit/io/version'

Gem::Specification.new do |spec|
  spec.name          = "adafruit-io"
  spec.version       = Adafruit::IO::VERSION
  spec.authors       = ["Justin Cooper", "Adam Bachman"]
  spec.email         = ["justin@adafruit.com"]
  spec.summary       = %q{Adafruit IO API Client Library}
  spec.description   = %q{API Client Library for the Adafruit IO product}
  spec.homepage      = "https://github.com/adafruit/io-client-ruby"
  spec.license       = "MIT"

  spec.files         = %w(LICENSE.md README.md Rakefile adafruit-io.gemspec)
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.licenses = ['MIT']

  spec.add_dependency "faraday", "~> 0.8"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "activesupport",  "~> 4.2"
  spec.add_dependency "mqtt", "~> 0.4"

  spec.add_development_dependency "bundler", "~> 2.2.10"
  spec.add_development_dependency "rake", "~> 12.3.3"
end
