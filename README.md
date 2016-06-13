![Build Status](https://travis-ci.org/adafruit/io-client-ruby.svg?branch=master)

# adafruit-io

A [Ruby][1] client for use with with [io.adafruit.com][2].

## Installation

Add this line to your application's Gemfile:

    gem 'adafruit-io'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adafruit-io

## Usage

Each time you use the library, you'll want to pass your [AIO Key][4] to the client.

```ruby

require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

```

## Table of Contents

* [Feeds](#feeds)
  * [Create](#feed-creation)
  * [Read](#feed-retrieval)
  * [Update](#feed-updating)
  * [Delete](#feed-deletion)
* [Data](#data)
  * [Create](#data-creation)
  * [Read](#data-retrieval)
  * [Update](#data-updating)
  * [Delete](#data-deletion)
  * [Helper Methods](#helper-methods)
    * [Send](#send)
    * [Next](#next)
    * [Last](#last)
    * [Previous](#previous)
  * [Readable](#readable-data)
  * [Writable](#writable-data)
* [Groups](#groups)
  * [Create](#group-creation)
  * [Read](#group-retrieval)
  * [Update](#group-updating)
  * [Delete](#group-deletion)

### Feeds

Feeds are the core of the Adafruit IO system. The feed holds metadata about data that gets pushed, and you will
have one feed for each type of data you send to the system. You can have separate feeds for each
sensor in a project, or you can use one feed to contain JSON encoded data for all of your sensors.

#### Feed Creation

You have two options here, you can create a feed by passing a feed name, or you can pass an object if you would
like to define more properties.  If you would like to find information about what properties are available, please
visit the [Adafruit IO feed API docs][3].

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

puts aio.feeds.create({:name => "Temperature"})
```

#### Feed Retrieval

You can get a list of your feeds by using the `aio.feeds.retrieve` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get all feeds
puts aio.feeds.retrieve
```

You can also get a specific feed by ID, key, or name by using the `aio.feeds.retrieve(id)` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get a single feed
feed = aio.feeds.retrieve("Temperature")
puts feed.name
puts feed.last_value
```
#### Feed Updating

You can update [feed properties][3] by retrieving a feed, and subsequently calling the save method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get the feed
feed = aio.feeds.retrieve("Temperature")
feed.name = "adsfsdff"
feed.description = "hey hey"
feed.save
```
#### Feed Deletion

You can delete a feed by ID, key, or name by retrieving a feed, and subsequently calling the delete method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

feed = aio.feeds.retrieve("Temperature")
puts feed.delete
```

### Data

Data represents the data contained in feeds. You can read, add, modify, and delete data. There are also
a few convienient methods for sending data to feeds and selecting certain pieces of data.

#### Data Creation

Data can be created [after you create a feed](#data-creation), by using the
`aio.feeds(id).data.create(value)` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds("Temperature").data.create({:value => 11})
puts data.inspect
```

#### Data Retrieval

You can get all of the data data by using the `aio.feeds(187).data.retrieve` method. The
callback will be called with errors and the data array as arguments.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.retrieve
puts data.inspect
```

You can also get a specific value by ID by using the `aio.feeds(id).data.retrieve(id)` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.retrieve(288718)
puts data.inspect
```

#### Data Updating

Values can be updated by retrieving the data, updating the property, and subsequently calling the save method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get the feed
data = aio.feeds("Temperature").data.last
data.value = "adsfsdff"
data.save
```

#### Data Deletion

Values can be deleted by retrieving the data, and calling the delete method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.retrieve(288718)
puts data.delete
```

#### Helper Methods

There are a few helper methods that can make interacting with data a bit easier.

##### Send

You can use the `aio.feeds(id).data.send_data(value)` method to find or create the feed based on the name passed,
and also save the value passed.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds("Test").data.send_data(5)
puts data.inspect
```

##### Last

You can get the last inserted value by using the `aio.feeds(id).data.last` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.last
puts data.inspect
```

##### Next

You can get the first inserted value that has not been processed by using the `aio.feeds(id).data.next` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.next
puts data.inspect
```

##### Previous

You can get the the last record that has been processed by using the `aio.feeds(id).data.previous` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

data = aio.feeds(187).data.previous
puts data.inspect
```

### Groups

Groups allow you to update and retrieve multiple feeds with one request. You can add feeds
to multiple groups.

#### Group Creation

You can create a group by passing an object of group properties.  If you would like to find
information about what properties are available, please visit the [Adafruit IO group API docs][5].

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

puts aio.groups.create({:name => "Greenhouse"})
```

#### Group Retrieval

You can get a list of your groups by using the `aio.groups.retrieve` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get all groups
#puts aio.groups.retrieve
```

You can also get a specific group by ID, key, or name by using the `aio.groups.retrieve(id)` method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

#get a single group
group = aio.groups.retrieve("First Group")
puts group.name
puts group.inspect
```
#### Group Updating

You can update [group properties][5] by retrieving a group, updating the object, and using the save method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => '463c8fc334cfb19318eAIO_KEY_HEREa0a17c01f5b985f77f545'

#get the group
group = aio.groups.retrieve("Greenhouse")
group.name = "Gymnasium"
group.description = "hey hey"
group.save

group.name = "Greenhouse"
group.description = "new description"
group.save
```

#### Group Deletion

You can delete a group by ID, key, or name by retrieving the group, and subsequently calling the delete method.

```ruby
require 'adafruit/io'

# create an instance
aio = Adafruit::IO::Client.new :key => 'AIO_KEY_HERE'

group = aio.groups.retrieve("Greenhouse")
puts group.delete
```

## License
Copyright (c) 2014 Adafruit Industries. Licensed under the MIT license.

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
