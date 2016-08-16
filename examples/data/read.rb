require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => ENV['ADAFRUIT_IO_KEY']

feed = aio.feeds.retrieve('beta-test')


# You can filter the data by data of creation, and you can set a limit on how
# many data points to retrieve:
data = feed.data.retrieve(nil,
                          start_time: '2016-08-15T20:24:00Z',
                          end_time: '2016-08-15T20:30:00Z',
                          limit: 3)

# or just get everything:
#
# data = feed.data.retrieve


if data && data.respond_to?(:size) && data.size > 0
  data.each do |d|
    puts %[\
    FEED  %s
    FIRST DATA
      ID         %s
      CREATED AT %s
      VALUE      %s
    ] % [feed.name, d.id, d.created_at, d.value]
  end
else
  puts "NO DATA AVAILABLE"
end
