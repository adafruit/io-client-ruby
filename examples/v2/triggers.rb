
require 'adafruit/io'
require 'securerandom'
require 'json'

api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

trigs = api.triggers

puts "all triggers:"
if trigs.empty?
  puts "  [empty]"
else
  puts JSON.pretty_generate(trigs)

  trigs.each do |trig|
    puts "- #{trig}"
  end
end

puts "-------------------------"

# 1) create a feed to watch
watch = api.create_feed(name: "Trigger Target #{SecureRandom.hex(4)}")

# 2) create a target feed for notifications
notify = api.create_feed(name: "Notifications #{SecureRandom.hex(4)}")

# 3) create a trigger that pings `notify` when `watch` goes over 50.
trigger = api.create_trigger(
  # react
  trigger_type: 'reactive',
  # when feed
  feed_id: watch['id'],
  # is greater than
  operator: 'gt',
  # 50
  value: '50',

  # by sending a message to feed
  action: 'feed',
  action_feed_id: notify['id'],

  # with value
  action_value: "#{watch['name']} over 50!",
)

puts "made a trigger: #{JSON.pretty_generate(trigger)}"
# %w(
#   feed_id operator value action to_feed_id action_feed_id action_value
#   enabled trigger_type
# )
