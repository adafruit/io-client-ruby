require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => ENV['ADAFRUIT_IO_KEY']

feed = aio.feeds.retrieve.first
data = aio.feeds(feed.key).data.retrieve.first

if data
  puts %[\
  FEED  %s
  FIRST DATA
    ID         %s
    CREATED AT %s
    VALUE      %s
  ] % [feed.name, data.value, data.created_at, data.feed_id]
else
  puts "NO DATA IN #{ feed.name }"
end
