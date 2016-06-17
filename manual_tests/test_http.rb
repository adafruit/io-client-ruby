#!/usr/bin/env ruby

$LOAD_PATH.unshift "manual_tests/lib"

require 'httpdirectfetch'

class TestObject
  include HTTPDirectFetch
end

puts "Test Adafruit IO API via HTTP REST calls"
run_all
