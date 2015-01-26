require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get the feed
data = aio.feeds("Temperature").data.last
data.value = "adsfsdff"
data.save
