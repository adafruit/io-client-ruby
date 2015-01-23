require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

group = aio.groups.retrieve("Greenhouse")
puts group.delete