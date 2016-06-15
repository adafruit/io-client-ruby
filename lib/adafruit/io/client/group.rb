require 'adafruit/io/client/io_object'

module Adafruit
  module IO
    class Group < IOObject
      def initialize(client = nil, id_or_key = nil)
        super(client, id_or_key)
      end

      def create(options = {})       
        response = @client.post 'groups', options
        return process_response(response)
      end

      def retrieve(id_or_key = nil, options = {})
        if id_or_key
          @id_or_key = id_or_key
          response = @client.get "groups/#{id_or_key}", options
        else
          response = @client.get 'groups', options
        end

        return process_response(response)
      end

      def delete
        response = @client.delete "groups/#{self.id}"
        if response == 200
          {"delete" => true, "id" => self.id}
        else
          {"delete" => false, "id" => self.id}
        end
      end

      def save
        response = @client.put "groups/#{self.id}", serialize_params(self)
        @unsaved_values.clear

        return process_response(response)
      end


      def send_group(group_name, data)
        if group_name
          group_name = URI::escape(group_name)
          post "groups/#{group_name}/send", {:value => data}
        else

        end
      end

      def receive_group(group_name)
        if group_name
          group_name = URI::escape(group_name)
          get "groups/#{group_name}/last"
        else

        end
      end

      def receive_next_group(group_name)
        if group_name
          group_name = URI::escape(group_name)
          get "groups/#{group_name}/next"
        else

        end
      end        

      def groups(feed_id_or_key, output_id=nil, options = {})
        if input_id
          get "groups/#{feed_id_or_key}/#{input_id}", options
        else
          get "groups/#{feed_id_or_key}", options
        end
      end

      def create_group(feed_id_or_key, options = {})       
        post "groups/#{feed_id_or_key}", options
      end

    end
  end
end
