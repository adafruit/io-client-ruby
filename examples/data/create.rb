require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => '463c8fc334cfb19318ea0a17c01f5b985f77f545'

data = aio.feeds("Temperature").data.create({:value => 11})
puts data.inspect