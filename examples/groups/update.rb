require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => '463c8fc334cfb19318eAIO_KEY_HEREa0a17c01f5b985f77f545'

#get the group
group = aio.groups.retrieve("Greenhouse")
group.name = "Gymnasium"
group.description = "hey hey"
group.save

group.name = "Greenhouse"
group.description = "new description"
group.save