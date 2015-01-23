require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get the feed
feed = aio.feeds.retrieve("Temperature")
feed.name = "adsfsdff"
feed.description = "hey hey"
feed.save

feed.description = "new description"
feed.save