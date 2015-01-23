require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

puts aio.groups.create({:name => "Greenhouse"})