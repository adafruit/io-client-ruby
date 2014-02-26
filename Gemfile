source 'https://rubygems.org'

group :test do
  gem 'coveralls', :require => false
  gem 'json', '~> 1.7', :platforms => [:ruby_18, :jruby]
  gem 'mime-types', '< 2.0.0'
  gem 'netrc', '~> 0.7.7'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec', '~> 2.13.0'
  gem 'simplecov', :require => false
  gem 'test-queue', '~> 0.1.3'
  gem 'vcr', '~> 2.4.0'
  gem 'webmock', '~> 1.9.0'
end

platforms :rbx do
  gem 'psych'
  gem 'rubysl', '~> 2.0'
end

# Specify your gem's dependencies in adafruit-io.gemspec
gemspec
