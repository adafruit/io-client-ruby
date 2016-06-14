require 'adafruit/io/client/io_object'
require 'adafruit/io/client/data'

module Adafruit
  module IO

    class Feed < IOObject
      def initialize(client = nil, id_or_key = nil)
        super(client, id_or_key)
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

      def data(id_or_key = nil)
        Adafruit::IO::Data.new(@client, self, id_or_key)
      end

      def to_s
        %[#<Adafruit::IO::Feed id=#{self.id} name=#{self.name} key=#{self.key}>]
      end

    end

  end
end
