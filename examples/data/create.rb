require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds("Temperature").data.create({:value => 11})
puts data.inspect