require 'mqtt'

#
# Adafruit::IO::MQTT provides a simple Adafruit IO aware wrapper around the
# Ruby MQTT library at https://github.com/njh/ruby-mqtt.
#
# Our primary goal is to provide basic MQTT access to feeds.
#
# For example, publishing to a feed is as simple as:
#
#     mqtt = Adafruit::IO::MQTT.new user, key
#     mqtt.publish('feed-key', 1)
#
# And subscribing to a feed is just as easy:
#
#     mqtt = Adafruit::IO::MQTT.new user, key
#     mqtt.subscribe('feed-key')
#     mqtt.get do |topic, value|
#       puts "GOT VALUE FROM #{topic}: #{value}"
#     end
#
# If you need to access different MQTT endpoints or data formats (JSON, CSV)
# you can use the MQTT library directly:
#
#     mqtt = Adafruit::IO::MQTT.new user, key
#     mqtt.client.get("#{user}/groups/group-key/json") do |topic, message|
#       payload = JSON.parse(message)
#       # etc...
#     end
#
# Documentation for Ruby MQTT is available at http://www.rubydoc.info/gems/mqtt/MQTT/Client
#
module Adafruit
  module IO
    class MQTT

      # provide access to the raw MQTT library client
      attr_reader :client

      def initialize(username, key, opts={})
        @options = {
          uri: 'io.adafruit.com',
          protocol: 'mqtts',
          port: 8883,
          username: username,
          key: key
        }.merge(opts)

        @connect_uri = "%{protocol}://%{username}:%{key}@%{uri}" % @options

        connect
      end

      def connect
        if @client.nil? || !@client.connected?
          @client = ::MQTT::Client.connect @connect_uri, @options[:port], ack_timeout: 10
        end
      end

      def disconnect
        if @client && @client.connected?
          @client.disconnect
        end
      end

      # Publish value to feed with given key
      def publish(key, value, location={})
        raise 'client is not connected' unless @client.connected?

        topic = key_to_feed_topic(key)
        location = indifferent_keys(location)
        payload = payload_from_value_with_location(value, location)

        @client.publish(topic, payload)
      end

      # Publish to multiple feeds within a group.
      #
      # - `key` is a group key
      # - `values` is a hash where keys are feed keys and values are the
      #   published value.
      # - `location` is the optional { :lat, :lon, :ele } hash specifying the
      #   location data for this publish event.
      #
      def publish_group(key, values, location={})
        raise 'client is not connected' unless @client.connected?
        raise 'values must be a hash' unless values.is_a?(Hash)

        topic = key_to_group_topic(key, false)
        location = indifferent_keys(location)
        payload = payload_from_values_with_location(values, location)

        @client.publish(topic, payload)
      end

      # Subscribe to the feed with the given key. Use .get to retrieve messages
      # from subscribed feeds.
      def subscribe(key)
        raise 'client is not connected' unless @client.connected?

        topic = key_to_feed_topic(key)
        @client.subscribe(topic)
      end

      def unsubscribe(key)
        raise 'client is not connected' unless @client.connected?

        topic = key_to_feed_topic(key)
        @client.unsubscribe(topic)
      end

      # Subscribe to a group with the given key.
      #
      # NOTE: Unlike feed subscriptions, group subscriptions return a JSON
      # representation of the group record with a 'feeds' property containing a
      # JSON object whose keys are feed keys and whose values are the last
      # value received for that feed.
      def subscribe_group(key)
        raise 'client is not connected' unless @client.connected?

        topic = key_to_group_topic(key)
        @client.subscribe(topic)
      end

      # Retrieve the last value received from the MQTT connection for any
      # subscribed feeds or groups. This is a blocking method, which means it
      # won't return until a message is retrieved.
      #
      # Returns [topic, message] or yields it into the given block.
      #
      # With no block:
      #
      #   mqtt_client.subscribe('feed-key')
      #   loop do
      #     topic, message = mqtt_client.get
      #     # do something
      #   end
      #
      # With a block:
      #
      #   mqtt_client.subscribe('feed-key')
      #   mqtt_client.get do |topic, message|
      #     # do something
      #   end
      #
      # NOTE: if a feed already has a value, subscribing and calling get will
      # immediately return the most recent value for the subscription,
      # regardless of when it was received by IO.
      def get(&block)
        @client.get(&block)
      end

      private

      def encode_json(record)
        begin
          JSON.generate record
        rescue JSON::GeneratorError => ex
          puts "failed to generate JSON from record: #{record.inspect}"
          raise ex
        end
      end

      def key_to_feed_topic(key)
        "%s/f/%s" % [@options[:username], key]
      end

      def key_to_group_topic(key, json=true)
        "%s/g/%s%s" % [@options[:username], key, (json ? '/json' : '')]
      end

      def payload_from_value_with_location(value, location)
        payload = { value: value.to_s }

        if location.has_key?('lat') && location.has_key?['lon']
          %w(lat lon ele).each do |f|
            payload[f] = location[f]
          end
        end

        encode_json payload
      end

      def payload_from_values_with_location(values, location)
        payload = { feeds: values }

        if location.has_key?('lat') && location.has_key?['lon']
          payload[:location] = {}

          %w(lat lon ele).each do |f|
            payload[:location][f] = location[f]
          end
        end

        encode_json payload
      end

      def indifferent_keys(hash)
        hash.keys.inject({}) {|new_hash, key|
          new_hash[key.to_s]   = hash[key]
          new_hash[key.to_sym] = hash[key]

          new_hash
        }
      end
    end
  end
end
