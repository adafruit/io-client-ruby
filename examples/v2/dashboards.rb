# Dashboards let you see your data on Adafruit IO. Dashboards are made of
# blocks, blocks subscribe to feeds through block_feeds.

require 'adafruit/io'

# to show all HTTP request activity from Faraday, add `debug: true`
api = Adafruit::IO::Client.new key: ENV['IO_KEY'], username: ENV['IO_USERNAME']
api.api_endpoint = ENV['IO_URL']
