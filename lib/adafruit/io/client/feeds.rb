module Adafruit
  module IO
    class Client
      module Feeds
        def feeds(id_or_key=nil, options = {})
          puts id_or_key
          if id_or_key
            get "feeds/#{id_or_key}", options
          else
            get 'feeds', options
          end
        end

        def create_feed(options = {})       
          post 'feeds', options
        end

      end
    end
  end
end