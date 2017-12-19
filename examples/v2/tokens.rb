
require 'adafruit/io'

api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

token = api.tokens[0]

puts "CURRENT TOKEN"
puts JSON.pretty_generate(token)
