require 'adafruit/io'

aio = Adafruit::IO::Client.new :key => '88cf494e3da8396fe3a121e7ed026a92db76885d'
#aio.out("Test Send", 22)
#client.create_feed({:name => "Weather Station", :mode => "output"})
#puts client.feeds(3)
aio.send_data("Test Send", 0)

10.times {
  aio.send_data("Test Send", Random.rand(101))
  sleep(1)
}