require 'adafruit/io'

aio = Adafruit::IO::Client.new :key => 'API_KEY_HERE'
aio.send_data("Test Send", 22)
puts aio.receive("Test Send")
#client.create_feed({:name => "Weather Station", :mode => "output"})
#puts client.feeds(3)
#aio.send_data("Test Send", 0)

#10.times {
#  aio.send_data("Test Send", Random.rand(101))
#  sleep(1)
#}

#puts aio.send_group("First Group", {"temperature" => 45, "humidity" => 32})

#hash = aio.receive_group("First Group")

puts hash