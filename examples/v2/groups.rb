# Feeds are where data is stored. Feeds can belong to one or more groups, all
# feeds are in the default group unless otherwise specified.

require 'adafruit/io'
require 'securerandom'

api_key = ENV['AIO_KEY']
username = ENV['AIO_USER']

api = Adafruit::IO::Client.new key: api_key, username: username
# api.api_endpoint = 'http://io.adafruit.vm'

# create a group
puts "create"
group = api.create_group(name: "Test Group #{SecureRandom.hex(4)}")
puts JSON.pretty_generate(group)
puts "-" * 80

# create a feed
feed = api.create_feed(name: "Test Feed #{SecureRandom.hex(4)}")

# add feed to group
puts "add feed"
added = api.group_add_feed(group, feed)
puts JSON.pretty_generate(added)
puts "-" * 80

# reload the group
puts "reload group"
group = api.group(group)
puts JSON.pretty_generate(group)
puts "-" * 80

# remove the feed from the group
puts "remove feed"
removed = api.group_remove_feed(group, feed)
puts JSON.pretty_generate(removed)
puts "-" * 80

# delete feed
puts "delete feed"
api.delete_feed(feed)

# delete group
puts "delete group"
api.delete_group(group)


