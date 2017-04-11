## The heart of Adafruit IO and priority for the API Library

require 'adafruit/io'

def section(label)
  puts "-" * 80
  puts "- " + label + " " + ("-" * (80 - label.size - 3))
  puts "-" * 80

  yield

  puts
end

api_key = '7a88d8e0abd24f45b7993d9f423b8873'
username = 'test_username'

api = Adafruit::IO::Client.new key: api_key, username: username
api.api_endpoint = 'http://io.adafruit.vm'

temperature = api.feed('temperature')

#
# Reporting on Data
#
# With /data API, get all data points with pagination
section 'Get All Temperatures' do
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
end
