# Dashboards let you see your data on Adafruit IO. Dashboards are made of
# blocks, blocks subscribe to feeds through block_feeds.

require 'adafruit/io'

# replace ENV['IO_KEY'] and ENV['IO_USERNAME'] with your key and username,
# respectively, or add IO_KEY and IO_USERNAME to your shell environment before
# you run this script
#
# to show all HTTP request activity add `debug: true`
api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
