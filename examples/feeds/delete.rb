require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

feed = aio.feeds.retrieve("Temperature")
puts feed.delete