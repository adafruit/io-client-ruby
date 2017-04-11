## The heart of Adafruit IO and priority for the API Library

require 'adafruit/io'
require 'securerandom'

api_key = ENV['AIO_KEY']
username = ENV['AIO_USER']

api = Adafruit::IO::Client.new key: api_key, username: username
api.api_endpoint = 'http://io.adafruit.vm'

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
# ... get nothing
puts api.feed(garbage['key']).inspect

