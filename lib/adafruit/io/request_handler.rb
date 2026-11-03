require 'adafruit/io/errors'

module Adafruit
  module IO
    module RequestHandler

      attr_reader :last_response, :pagination

      def request(method, url, data = nil)
        @pagination = nil
        @last_response = send(method, url, data)
      end

      def get(url, options = {})
        request(:handle_get, url, options)
      end

      def post(url, data)
        request :handle_post, url, data
      end

      def put(url, data)
        request :handle_put, url, data
      end

      def delete(url)
        request :handle_delete, url
      end

      def last_page?
        pagination.nil? || (pagination['limit'] != pagination['count'])
      end

      private

      def update_pagination(response)
        @pagination = nil

        pagination_keys = response.headers.keys.grep(/x-pagination-/i)
        return if pagination_keys.empty?

        @pagination = {}
        pagination_keys.each do |k|
          @pagination[k.gsub(/x-pagination-/i, '')] = response.headers[k]
        end
      end

      # Faraday's :json middleware already parses responses with a JSON
      # content type. Only try to parse bodies it left as strings.
      def parsed_response(response)
        body = response.body
        return body unless body.is_a?(String)

        begin
          JSON.parse(body)
        rescue JSON::ParserError
          body
        end
      end

      def handle_get(url, options = {})
        response = conn.get do |req|
          req.url url
          options.each do |k,v|
            req.params[k] = v
          end
        end

        update_pagination(response)

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("GET error: #{ response.body }", response)
        else
          parsed_response response
        end
      end

      def handle_post(url, data)
        response = conn.post do |req|
          req.url url
          req.body = data
        end

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("POST error: #{ response.body }", response)
        else
          parsed_response response
        end
      end

      def handle_put(url, data)
        response = conn.put do |req|
          req.url url
          req.body = data
        end

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("PUT error: #{ response.body }", response)
        else
          parsed_response response
        end
      end

      def handle_delete(url, _data = nil)
        response = conn.delete do |req|
          req.url url
        end

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("DELETE error: #{ response.body }", response)
        else
          parsed_response response
        end
      end
    end
  end
end
