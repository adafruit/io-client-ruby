module Adafruit
  module IO
    class Client
      module RequestHandler
        def handle_get(url, data = nil, options = {})
          response = conn.get do |req|
            req.url "api/#{url}"
            #req.params['limit'] = 100
          end
          return response.body
        end

        def handle_post(url, data, options = {})
          response = conn.post do |req|
            req.url "api/#{url}"
            req.body = data
          end
          return response.body
        end

        def handle_put(url, data, options = {})
          response = conn.put do |req|
            req.url "api/#{url}"
            req.body = data
          end
          return response.body
        end        
      end
    end
  end
end