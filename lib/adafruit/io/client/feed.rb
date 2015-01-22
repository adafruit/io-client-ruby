require 'uri'
require 'adafruit/io/client'

module Adafruit
  module IO

      class Feed

        def initialize(client = nil, id_or_key = nil)
          @client = client
          @id_or_key = id_or_key
        end

        def create(options = {})       
          response = post 'feeds', options
          return build_response(response)
        end

        def retrieve(id_or_key = nil, options = {})
          if id_or_key
            response = @client.get "feeds/#{id_or_key}", options
          else
            response = @client.get 'feeds', options
          end

          return process_response(response)
        end

        def update

        end

        def delete

        end

        def save

        end

      protected

        def process_response(response)
          response = JSON.parse(response, :symbolize_names => true)

          if response.is_a?(Array)
            obj_list = []
            response.each do |r|
              obj_list.push(Feed.new.parse(r))
            end
          else
            obj_list = Feed.new.parse(response)
          end

          return obj_list
        end

        def parse(o)
          o.each do |k, v|
            singleton_class.class_eval do; attr_accessor "#{k}"; end
            send("#{k}=", v)
          end

          return self
        end

      end

  end
end