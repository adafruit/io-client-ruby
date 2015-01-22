require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'API_KEY_HERE'

#get all feeds
feeds = aio.feeds
puts feeds.length
puts feeds[0]

#get a single feed
puts aio.feeds("Temperature")