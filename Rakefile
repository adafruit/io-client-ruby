require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = "iolib"
  t.test_files = FileList[ 'manual_tests/test_iolib.rb' ]
  t.verbose = true
end

Rake::TestTask.new do |t|
  t.name = "http"
  t.test_files = FileList[ 'manual_tests/test_http.rb' ]
  t.verbose = true
end
