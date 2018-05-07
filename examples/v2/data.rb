# Data is the heart of Adafruit IO and priority for the API Library. All data
# is stored and retreived in the context of a Feed.

require 'adafruit/io'

# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api_key = ENV['IO_KEY']
username = ENV['IO_USERNAME']
api = Adafruit::IO::Client.new key: api_key, username: username

feed_key = "temperature-#{rand(1000000)}"

temperature = api.feed(feed_key) rescue nil
if temperature.nil?
  temperature = api.create_feed name: feed_key
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
  results = api.data(temperature['key'], limit: 10, end_time: end_time)
  print '.'

  all_temperatures = all_temperatures.concat(results)

  break if api.last_page?
  end_time = api.pagination['start']

  sleep 3
end
puts

all_temperatures.each do |temp|
  puts "%-32s%-16.3f%-30s" % [temp['id'], temp['value'].to_f, temp['created_at']]
end
