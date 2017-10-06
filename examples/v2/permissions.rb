# Permissions control who can see what feeds.

require 'adafruit/io'

api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

# If permissions test feed doesn't exist, create it
feed = api.feed('permissions-test')
if feed.nil?
  puts 'creating feed "Permissions Test"'
  feed = api.create_feed(name: 'Permissions Test', key: 'permissions-test')
end

# get all permissions for a feed
permissions = api.permissions('feeds', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"

# create (or update) public permission record for the feed
perm = api.create_permission 'feeds', feed['key'], scope: 'public', mode: 'r'
puts "add public read key to #{feed['name']} -> #{perm}"

permissions = api.permissions('feeds', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"

# make the feed private again
del = api.delete_permission 'feeds', feed['key'], perm['id']
puts "deleted #{perm['id']} from #{feed['name']}"

permissions = api.permissions('feeds', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"
