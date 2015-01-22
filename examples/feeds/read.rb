require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get all feeds
puts aio.feeds.retrieve

#get a single feed
feed = aio.feeds.retrieve("Temperature")
puts feed.name
puts feed.last_value