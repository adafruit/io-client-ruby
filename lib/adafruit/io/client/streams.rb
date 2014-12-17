require 'uri'

module Adafruit
  module IO
    class Client
      module Streams
        def send_data(feed_name, data)
          if feed_name
            feed_name = URI::escape(feed_name)
            post "feeds/#{feed_name}/streams/send", {:value => data}
          else

          end
        end

        def receive(feed_name)
          if feed_name
            feed_name = URI::escape(feed_name)
            get "feeds/#{feed_name}/streams/last"
          else

          end
        end

        def receive_next(feed_name)
          if feed_name
            feed_name = URI::escape(feed_name)
            get "feeds/#{feed_name}/streams/next", {:value => data}
          else

          end
        end        

        def streams(feed_id_or_key, output_id=nil, options = {})
          if input_id
            get "feeds/#{feed_id_or_key}/streams/#{input_id}", options
          else
            get "feeds/#{feed_id_or_key}/streams", options
          end
        end

        def create_stream(feed_id_or_key, options = {})       
          post "feeds/#{feed_id_or_key}/streams", options
        end
      end
    end
  end
end