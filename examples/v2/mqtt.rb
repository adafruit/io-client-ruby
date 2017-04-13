
require 'adafruit/io'

api_key = ENV['AIO_KEY']
username = ENV['AIO_USER']

# Optionally set uri (hostname of Adafruit IO compatible MQTT service),
# protocol, and port.
mqtt = Adafruit::IO::MQTT.new(username, api_key,
  uri: 'io.adafruit.us',
  protocol: 'mqtts',
  port: 8883
)

# background listener
Thread.new do
  # subscriptions accumulate, so calling .subscribe multiple times will cause
  # each feed to be subscribed to
  mqtt.subscribe('feed-a')
  mqtt.subscribe('feed-b')

  # subscribing to groups gets a Group JSON message
  mqtt.subscribe_group('default')

  # get messages as they are received
  loop do
    topic, message = mqtt.get
    puts "[receiving plain %s %s] %s" % [topic, Time.now, message]
  end

  # OR with a block
  # mqtt.get do |topic, message|
  #   puts "[receiving block %s %s] %s" % [topic, Time.now, message]
  # end
end

value = 1
loop do
  puts "[publishing] #{value}"

  # mqtt.publish('sample-data', value)
  mqtt.publish_group('default', {
    'feed-a' => value * rand(),
    'feed-b' => value * rand(),
  })

  value = (value + 1) % 100
  sleep 10
end
