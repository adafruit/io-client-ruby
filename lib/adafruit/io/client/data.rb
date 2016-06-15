require 'adafruit/io/client/io_object'
require 'adafruit/io/client/feed'

module Adafruit
  module IO
    class Data < IOObject
      def initialize(client = nil, feed = nil, id_or_key = nil)
        super(client, id_or_key)

        @feed = feed
        @base_url = "feeds/#{@feed.id_or_key}"
      end

      def create(options = {})
        response = @client.post "#{@base_url}/data", options
        return process_response(response)
      end

      def retrieve(id_or_key = nil, options = {})
        if id_or_key
          @id_or_key = id_or_key
          response = @client.get "#{@base_url}/data/#{id_or_key}", options
        else
          response = @client.get "#{@base_url}/data", options
        end

        return process_response(response)
      end

      def delete
        response = @client.delete "#{@base_url}/data/#{self.id}"
        if response == 200
          {"delete" => true, "id" => self.id}
        else
          {"delete" => false, "id" => self.id}
        end
      end

      def save
        response = @client.put "#{@base_url}/data/#{self.id}", serialize_params(self)
        @unsaved_values.clear

        return process_response(response)
      end

      def send_data(data)
        response = @client.post "#{@base_url}/data/send", {:value => data}
        return process_response(response)
      end

      def receive
        response = @client.get "#{@base_url}/data/last"
        return process_response(response)
      end

      def last
        receive
      end

      def next
        response = @client.get "#{@base_url}/data/next"
        return process_response(response)
      end

      def previous(feed_name)
        response = @client.get "#{@base_url}/data/previous"
        return process_response(response)
      end
    end
  end
end
