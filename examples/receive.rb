require 'adafruit/io'

aio = Adafruit::IO::Client.new :key => 'API_KEY_HERE'
puts aio.receive("Temperature")