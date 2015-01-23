require 'adafruit/io/client/io_object'

module Adafruit
  module IO

    class Feed < IOObject
      attr_accessor :unsaved_values

      def initialize(client = nil, id_or_key = nil)
        @client = client
        @id_or_key = id_or_key
        @unsaved_values = Set.new
        @values = {}
      end

      def create(options = {})       
        response = @client.post 'feeds', options
        return process_response(response)
      end

      def retrieve(id_or_key = nil, options = {})
        if id_or_key
          @id_or_key = id_or_key
          response = @client.get "feeds/#{id_or_key}", options
        else
          response = @client.get 'feeds', options
        end

        return process_response(response)
      end

      def delete
        response = @client.delete "feeds/#{self.id}"
        if response == 200
          {"delete" => true, "id" => self.id}
        else
          {"delete" => false, "id" => self.id}
        end
      end

      def save
        response = @client.put "feeds/#{self.id}", serialize_params(self)
        @unsaved_values.clear

        return process_response(response)
      end
    end

  end
end