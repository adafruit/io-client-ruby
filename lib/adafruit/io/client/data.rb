require 'uri'

module Adafruit
  module IO
    class Client
      module Data
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
end