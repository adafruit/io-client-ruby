# Adafruit::IO

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'adafruit-io'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adafruit-io

## Usage

  Easiest
  
    require 'adafruit/io'
    aio = Adafruit::IO::Client.new :key => 'unique_key_id'
    #data can be of any type, string, number, hash, json
    aio.send("Feed Name", data)

    #You can also receive data easily:
    value = aio.receive("Feed Name")

    #It will ge the next input available, and mark it as read.


  Advanced

    require 'adafruit/io'
    client = Adafruit::IO::Client.new :key => 'unique_key_id'

    #get all of your feeds for the key
    client.feeds

    #get a specific feed using ID or Name
    client.feeds(3)
    client.feeds("feed name")

    #create a feed
    client.create_feed({:name => "New Feed Name", ...})

## Contributing

1. Fork it ( http://github.com/adafruit/io-client-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request