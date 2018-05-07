# Feeds are where data is stored. Feeds can belong to one or more groups, all
# feeds are in the default group unless otherwise specified.

require 'adafruit/io'
require 'securerandom'

# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api_key = ENV['IO_KEY']
username = ENV['IO_USERNAME']
api = Adafruit::IO::Client.new key: api_key, username: username

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
  if ex.response.status === 404
    puts "expected error #{ex.response.status}: #{ex.message}"
  else
    puts "unexpected error! #{ex.message}"
  end
end

