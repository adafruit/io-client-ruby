# Activities are the history of your activity on Adafruit IO.

require 'adafruit/io'

def actify(action)
  action.end_with?('e') ?
    (action + 'd').upcase :
    (action + 'ed').upcase
end

def nice_time(tstring)
  time = Time.parse(tstring)
  time.strftime('%Y-%m-%d %r')

end

api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']

activities = api.activities


activities.each do |act|
  if act['model'] === 'Feed'
    puts JSON.pretty_generate(act)
  end
  puts "%s    I %s A %s NAMED \"%s\"" % [
    nice_time(act['created_at']),
    actify(act['action']),
    act['model'].upcase,
    act['data']['name']
  ]
end

# permanently clear activity history
# api.delete_activities
