
require 'adafruit/io'

# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api_key = ENV['IO_KEY']
username = ENV['IO_USERNAME']
api = Adafruit::IO::Client.new key: api_key, username: username

token = api.tokens[0]

puts "CURRENT TOKEN"
puts JSON.pretty_generate(token)
