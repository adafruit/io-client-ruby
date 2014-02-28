require 'uri'

module Adafruit
  module IO
    class Client
      module Outputs
        def out(feed_name, data = nil)
          feed_name = URI::escape(feed_name)
          if feed_name
            post "feeds/#{feed_name}/outputs/send", {:value => data}
          else

          end
        end

        def outputs(feed_id_or_key, output_id=nil, options = {})
          if output_id
            get "feeds/#{feed_id_or_key}/outputs/#{output_id}", options
          else
            get "feeds/#{feed_id_or_key}/outputs", options
          end
        end

        def create_output(feed_id_or_key, options = {})       
          post "feeds/#{feed_id_or_key}/outputs", options
        end
      end
    end
  end
end