# Example script using Adafruit::IO::MQTT to access adafruit.io
# - Nicholas Humfrey has an excellent MQTT library, which is very easy to use.

require 'adafruit/io'

username = ENV['IO_USERNAME']
key = ENV['IO_KEY']
feed = 'welcome'

connection_opts = {
  port: 8883,
  uri: 'io.adafruit.com',
  protocol: 'mqtts'
}

mqtt = Adafruit::IO::MQTT.new username, key, connection_opts

Thread.new do
  puts "subscribe to #{feed}"
  mqtt.subscribe(feed, last_value: true)

  mqtt.get do |topic, message|
    puts "<- received #{feed} #{message} at #{Time.now.to_f}"
  end
end

# pause while subscription sets up in other thread
sleep 2

5.times do |n|
  mqtt.publish feed, n
  puts "-> published #{n} at #{Time.now.to_f}"
  sleep 5
end

# output should look something like:
#
#     $ ruby -Ilib/ examples/mqtt.rb
#     subscribe to welcome
#     <- received welcome 1 at 1525728547.548456
#     -> published 0 at 1525728549.474504
#     <- received welcome 0 at 1525728549.524008
#     -> published 1 at 1525728554.477849
#     <- received welcome 1 at 1525728554.524014
#     -> published 2 at 1525728559.4833012
#     <- received welcome 2 at 1525728559.5317278
#     -> published 3 at 1525728564.487375
#     <- received welcome 3 at 1525728564.5310678
#     -> published 4 at 1525728569.490098
#     <- received welcome 4 at 1525728569.54076
#
