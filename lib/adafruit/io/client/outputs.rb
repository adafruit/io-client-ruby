require 'uri'

module Adafruit
  module IO
    class Client
      module Outputs
        def out(name, data)
          name = URI::escape(name)
          if name
            post "feeds/#{name}/outputs/out", {:value => data}
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