require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => '4ef83270a2f96d6402002045fba9088f9220552d'

#get all feeds

puts aio.feeds.retrieve
#puts feeds.retrieve
#puts feeds[0]

#get a single feed
feed = aio.feeds.retrieve("Temperature")
puts feed.name
puts feed.last_value