# Permissions control who can see what feeds.

require 'adafruit/io'

# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api_key = ENV['IO_KEY']
username = ENV['IO_USERNAME']
api = Adafruit::IO::Client.new key: api_key, username: username

# If permissions test feed doesn't exist, create it
feed = api.feed('permissions-example') rescue nil
if feed.nil?
  puts 'creating feed "Permissions Test"'
  feed = api.create_feed(name: 'Permissions Test', key: 'permissions-example')
end

# get all permissions for a feed
permissions = api.permissions('feed', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"

# create (or update) public permission record for the feed
perm = api.create_permission 'feed', feed['key'], scope: 'public', mode: 'r'
puts "add public read permission to #{feed['name']} -> #{perm}"

permissions = api.permissions('feed', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"

# make the feed private again
del = api.delete_permission 'feed', feed['key'], perm['id']
puts "deleted #{perm['id']} from #{feed['name']}"

permissions = api.permissions('feed', feed['key'])
puts "#{feed['name']} has permissions #{permissions}"

api.delete_feed('permissions-example')
puts "deleted example feed"

