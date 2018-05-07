# Feeds are where data is stored. Feeds can belong to one or more groups, all
# feeds are in the default group unless otherwise specified.

require 'adafruit/io'
require 'securerandom'

api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

# create a feed
puts "create"
garbage = api.create_feed(name: "Garbage #{SecureRandom.hex(4)}")

# add data
puts "add data"
api.send_data garbage, 'something'
api.send_data garbage, 'goes here'

# load data
puts "load data"
data = api.data(garbage)
puts "#{data.size} points: #{ data.map {|d| d['value']}.join(', ') }"

# get details
puts "read"
puts JSON.pretty_generate(api.feed_details(garbage))

# delete feed
puts "delete"
api.delete_feed(garbage)

# try reading
puts "read?"
# ... get 404
begin
  api.feed(garbage['key'])
rescue => ex
  puts "ERROR #{ex.response.status}: #{ex.message}"
end

