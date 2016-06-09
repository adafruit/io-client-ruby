require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => ENV['ADAFRUIT_IO_KEY']

#get all feeds
feeds = aio.feeds.retrieve
puts feeds

#get a single feed
feed = aio.feeds.retrieve(feeds.last.key)
puts feed.name
puts feed.last_value
