require 'adafruit/io'

aio = Adafruit::IO::Client.new :key => 'API_KEY_HERE'
aio.send_data("Temperature", 22)