
require 'adafruit/io'

def section(label)
  puts "-" * 80
  puts "- " + label + " " + ("-" * (80 - label.size - 3))
  puts "-" * 80

  yield

  puts
end

# to show all HTTP request activity from Faraday, add `debug: true`
api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

section 'Client Prepared' do
  puts api.inspect
end

temperature = nil
humidity = nil

section 'Getting or Creating Feeds' do
  temperature = api.feed_details('temperature')
  if temperature.nil?
    puts "<creating Temperature feed>"
    temperature = api.create_feed(name: 'Temperature')
  end

  humidity = api.feed_details('humidity')
  if humidity.nil?
    puts "<creating Humidity feed>"
    humidity = api.create_feed(name: 'Humidity')
  end

  puts "%-12s%-12s%s" % %w(Name Key Created_At)
  puts
  puts "%-12s%-12s%s" % [ temperature['name'], temperature['key'], temperature['created_at'] ]
  puts "%-12s%-12s%s" % [ humidity['name'], humidity['key'], humidity['created_at'] ]
end

# simple random value in a range
def rand_in(min, max)
  (rand() * (max - min)) + min
end

# random location in valid format
def rand_location
  {lat: rand_in(40, 50), lon: rand_in(40, 80) * -1, ele: rand_in(200, 400)}
end

new_temp = nil
new_humid = nil

section 'Adding Data' do
  #
  # Add Data
  #
  #   api.send_data feed_key, value, [ location ]
  #
  loc = rand_location()
  new_temp = api.send_data(temperature['key'], rand_in(20, 40), loc)
  puts "new temperature value: "
  puts JSON.pretty_generate(new_temp)

  new_humid = api.send_data(humidity['key'], rand_in(40, 90), loc)
  puts "new humidity value: "
  puts JSON.pretty_generate(new_humid)
end

#
# Reporting on Data
#
# With /data API, get all data points with pagination
section 'Get All Temperatures' do
  all_temperatures = api.data(temperature['key'])
  puts "%-24s%-16s%-30s" % ['ID', 'Temperature', 'Timestamp']
  all_temperatures.each do |temp|
    puts "%-24s%-16.3f%-30s" % [temp['id'], temp['value'].to_f, temp['created_at']]
  end
end

# With /chart API, get graphable data points with timestamps and (possible) aggregation
#
# Chart data is returned as a JSON record with these keys and nested objects:
#
#   {
#     feed: { id, name, key },
#     parameters: { start_time, end_time, hours, [ resolution ] },
#     columns: [ date, value ],
#     data: [
#       [$date, $value],
#       ...
#     ]
#   }
#
section 'Get Humidity Chart' do
  humidity_chart = api.data_chart(humidity['key'], hours: 4)
  puts "%-28s%8s" % ['Time', 'Humidity']
  humidity_chart['data'].each do |point|
    puts "%-28s%8.2f %s" % [point[0], point[1], ('-' * point[1].to_i)]
  end
end


section 'Working with data as a stream' do

  5.times do
    point = api.next_data(temperature['key'])
    puts "POINT #{point.inspect}"
    # puts "TEMPERATURE %s %0.3f" % [ point['id'], point['value'].to_f ]
  end

end
