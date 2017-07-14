# Data is the heart of Adafruit IO and priority for the API Library. All data
# is stored and retreived in the context of a Feed.

require 'adafruit/io'

api_key = ENV['AIO_KEY']
username = ENV['AIO_USER']

api = Adafruit::IO::Client.new key: api_key, username: username
api.api_endpoint = 'http://io.adafruit.vm'

temperature = api.feed('temperature')
if temperature.nil?
  temperature = api.create_feed name: "Temperature"
end

#
# Adding data
#

# generate some garbage data
yesterday = (Time.now - 60 * 60 * 24)
points = []
20.times do |n|
  points << {value: rand() * 50, created_at: (yesterday + n * 10).utc.iso8601}
end

# and send it as a batch
api.send_batch_data(temperature, points)

#
# Reading data
#
# With /data API, get all data points with pagination
all_temperatures = []
end_time = Time.now

loop do
  results = api.data(temperature['key'], limit: 4, end_time: end_time)
  print '.'

  all_temperatures = all_temperatures.concat(results)

  break if api.last_page?
  end_time = api.pagination['start']
end
puts

all_temperatures.each do |temp|
  puts "%-24s%-16.3f%-30s" % [temp['id'], temp['value'].to_f, temp['created_at']]
end
