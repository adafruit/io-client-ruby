require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => ENV['AIO_KEY']

# use `create` to target an existing Feed
data = aio.feeds("Temperature").data.create({:value => 11})

# or use `send_data` to send a single value and auto-create the Feed if necessary
data2 = aio.feeds("Temperature").data.send_data(12)

puts data.inspect
puts data2.inspect
