require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get all groups
#puts aio.groups.retrieve

#get a single group
group = aio.groups.retrieve("First Group")
puts group.name
puts group.inspect