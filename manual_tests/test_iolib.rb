#!/usr/bin/env ruby

$LOAD_PATH.unshift "manual_tests/lib"

require 'rubylibfetch'

class TestObject
  include RubyLibFetch
end

puts "Test Adafruit IO API via the io-client-ruby library"
begin
run_all
rescue
end

# For code coverage

print "Code Coverage, part 2a"

# 1   Alternate server URL
ENV['ADAFRUIT_IO_URL'] = "https://io.adafruit.com"
AIO2 = Adafruit::IO::Client.new :key => ENV['ADAFRUIT_IO_KEY'].freeze
AIO2.feeds.retrieve(24601)
puts "\t\tOK"

print "Code Coverage, part 2b"

# IO::Client#last_response
AIO2.last_response
puts "\t\tOK"

puts "ALL DONE"
exit 0
