require 'adafruit/io/client/io_object'

module Adafruit
  module IO
    class Data < IOObject
      def initialize(client = nil, id_or_key = nil)
        @client = client
        @id_or_key = id_or_key
        @unsaved_values = Set.new
        @values = {}
      end

      def create(options = {})       
        response = @client.post 'data', options
        return process_response(response)
      end

      def retrieve(id_or_key = nil, options = {})
        if id_or_key
          @id_or_key = id_or_key
          response = @client.get "data/#{id_or_key}", options
        else
          response = @client.get 'data', options
        end

        return process_response(response)
      end

      def delete
        response = @client.delete "data/#{self.id}"
        if response == 200
          {"delete" => true, "id" => self.id}
        else
          {"delete" => false, "id" => self.id}
        end
      end

      def save
        response = @client.put "data/#{self.id}", serialize_params(self)
        @unsaved_values.clear

        return process_response(response)
      end

      def send_data(feed_name, data)
        if feed_name
          feed_name = URI::escape(feed_name)
          post "feeds/#{feed_name}/data/send", {:value => data}
        else

        end
      end

      def receive(feed_name)
        if feed_name
          feed_name = URI::escape(feed_name)
          get "feeds/#{feed_name}/data/last"
        else

        end
      end

      def receive_next(feed_name)
        if feed_name
          feed_name = URI::escape(feed_name)
          get "feeds/#{feed_name}/data/next", {:value => data}
        else

        end
      end        

      def data(feed_id_or_key, output_id=nil, options = {})
        if input_id
          get "feeds/#{feed_id_or_key}/data/#{input_id}", options
        else
          get "feeds/#{feed_id_or_key}/data", options
        end
      end

      def create_data(feed_id_or_key, options = {})       
        post "feeds/#{feed_id_or_key}/data", options
      end
    end
  end
end