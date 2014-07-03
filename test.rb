require 'adafruit/io'

aio = Adafruit::IO::Client.new :key => 'a052ecc32b2de1c80abc03bd471acd1d6b218e5c'
#aio.out("Test Send", 22)
#client.create_feed({:name => "Weather Station", :mode => "output"})
#puts client.feeds(3)
#aio.send_data("Test Send", 0)

#10.times {
#  aio.send_data("Test Send", Random.rand(101))
#  sleep(1)
#}

#puts aio.send_group("First Group", {"temperature" => 45, "humidity" => 32})

hash = aio.receive_group("First Group")

puts hash