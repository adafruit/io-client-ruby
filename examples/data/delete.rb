require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.retrieve(288718)
puts data.delete