require 'open-uri'

module Adafruit
  module IO
    class Client
      module RequestHandler
        def handle_get(url, data = nil, options = {})
          response = conn.get do |req|
            req.url URI::encode("api/#{url}")
            #req.params['limit'] = 100
          end
          return response.body
        end

        def handle_post(url, data, options = {})
          response = conn.post do |req|
            req.url URI::encode("api/#{url}")
            req.body = data
          end
          return response.body
        end

        def handle_put(url, data, options = {})
          response = conn.put do |req|
            req.url URI::encode("api/#{url}")
            req.body = data
          end
          return response.body
        end

        def handle_delete(url, options = {})
          response = conn.delete do |req|
            req.url URI::encode("api/#{url}")
          end
          return response.status
        end 
      end
    end
  end
end