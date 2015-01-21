require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'API_KEY_HERE'

puts aio.create_feed({:name => "Temperature"})