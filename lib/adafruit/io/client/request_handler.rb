module Adafruit
  module IO
    class Client
      module RequestHandler
        def handle_get(url, options = {})
          response = conn.get do |req|                           # GET http://sushi.com/search?page=2&limit=100
            req.url "api/#{url}"
            #req.params['limit'] = 100
          end
          return response.body
        end

        def handle_post(url, options = {})
          response = conn.post do |req|                           # GET http://sushi.com/search?page=2&limit=100
            req.url '/api/feeds'
            req.body = options
          end
          return response.body
        end
      end
    end
  end
end