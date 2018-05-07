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


# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']

activities = api.activities

activities.each do |act|
  puts "%s  I %s A %s NAMED \"%s\"" % [
    nice_time(act['created_at']),
    actify(act['action']),
    act['model'].upcase,
    act['data']['name']
  ]
end

# permanently clear activity history
# api.delete_activities
