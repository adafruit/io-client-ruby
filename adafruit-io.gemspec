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

  spec.add_dependency "faraday", "~> 2.14"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "activesupport",  "~> 8.0"
  spec.add_dependency "mqtt", "~> 0.7"

  spec.add_development_dependency "bundler", "~> 2.7"
  spec.add_development_dependency "rake", "~> 13.2"
end
