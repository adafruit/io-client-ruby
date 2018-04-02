![Build Status](https://travis-ci.org/adafruit/io-client-ruby.svg?branch=master)

# adafruit-io

A [Ruby][1] client for use with with [io.adafruit.com][2].

Note, this documentation covers the gem supporting V2 of the API, which is currently under active development and may be missing some features. It also breaks support for code that used version <= 1.0.4 of this library.

Older releases are available at these links:

* [1.0.4](https://github.com/adafruit/io-client-ruby/tree/v1.0.4)
* [1.0.3](https://github.com/adafruit/io-client-ruby/tree/v1.0.3)
* [1.0.0](https://github.com/adafruit/io-client-ruby/tree/v1.0.0)

This is a near complete rewrite and strip-down of the library intended to support V2 of the Adafruit IO API with less code, maintenance, and stress.

Why rewrite? This lets us the replace the existing, custom ActiveRecord-based interface with a flat, stateless API client returning plain hashes based on the JSON returned from API.Instead of writing a bunch of Ruby to make it feel like we're in a Rails app, we're just providing hooks into the API and a thin wrapper around Faraday.

The API is not very complex, code that uses it shouldn't be either.

## Roadmap

It is our goal to eventually support all API V2 methods, but that will happen in stages.

- [x] Feeds `2.0.0.beta.1`
- [x] Data `2.0.0.beta.1`
- [x] Groups `2.0.0.beta.1`
- [x] MQTT `2.0.0.beta.3`
- [x] Tokens `2.0.0.beta.4`
- [x] Blocks `2.0.0.beta.4`
- [x] Dashboards `2.0.0.beta.4`
- [x] Activities `2.0.0.beta.5`
- [x] Permissions `2.0.0.beta.5`
- [x] Triggers `2.0.0.beta.6`

Still needing tests:

- [x] Feeds
- [x] Data
- [x] Groups
- [x] Tokens
- [x] Blocks
- [x] Dashboards
- [ ] Activities
- [ ] Permissions
- [ ] Triggers
- [ ] MQTT

## Installation

Add this line to your application's Gemfile:

    gem 'adafruit-io'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adafruit-io

## Basic Usage

Each time you use the library, you'll want to pass your [AIO Key][4] to the client.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new key: 'KEY'
```

Since every API request requires a username, you can also pass a username to the client initializer to use it for every request.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new key: 'KEY', username: 'USERNAME'
```

All return values are plain Ruby hashes based on the JSON response returned by the API. Most basic requests should get back a Hash with a `key` field. The key can be used in subsequent requests. API requests that return a list of objects will return a simple array of hashes. Feeds, Groups, and Dashboards all rely on the `key` value, other endpoints (Blocks, Permissions, Tokens, Triggers) use `id`.

Here's an example of creating, adding data to, and deleting a feed.

```ruby
require 'adafruit/io'

api_key = ENV['AIO_KEY']
username = ENV['AIO_USER']

api = Adafruit::IO::Client.new key: api_key, username: username

# create a feed
puts "create"
garbage = api.create_feed(name: "Garbage 123")

# add data
puts "add data"
api.send_data garbage, 'something'
api.send_data garbage, 'goes here'

# load data
puts "load data"
data = api.data(garbage)
puts "#{data.size} points: #{ data.map {|d| d['value']}.join(', ') }"

# get details
puts "read"
puts JSON.pretty_generate(api.feed_details(garbage))

# delete feed
puts "delete"
api.delete_feed(garbage)

# try reading
puts "read?"
# ... get nothing
puts api.feed(garbage['key']).inspect
```

## License

Copyright (c) 2017 Adafruit Industries. Licensed under the MIT license.

[Adafruit](https://adafruit.com) invests time and resources providing this open source code. Please support Adafruit and open-source hardware by purchasing products from [Adafruit](https://adafruit.com).

## Contributing

1. Fork it ( http://github.com/adafruit/io-client-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: https://www.ruby-lang.org
[2]: https://io.adafruit.com
[3]: https://learn.adafruit.com/adafruit-io/feeds
[4]: https://learn.adafruit.com/adafruit-io/api-key
[5]: https://learn.adafruit.com/adafruit-io/groups
