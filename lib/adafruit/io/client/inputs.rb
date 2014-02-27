require 'uri'

module Adafruit
  module IO
    class Client
      module Inputs
        def in(name, data)
          name = URI::escape(name)
          if name
            post "feeds/#{name}/inputs/send", {:value => data}
          else

          end
        end

        def inputs(feed_id_or_key, output_id=nil, options = {})
          if input_id
            get "feeds/#{feed_id_or_key}/inputs/#{input_id}", options
          else
            get "feeds/#{feed_id_or_key}/inputs", options
          end
        end

        def create_input(feed_id_or_key, options = {})       
          post "feeds/#{feed_id_or_key}/inputs", options
        end
      end
    end
  end
end