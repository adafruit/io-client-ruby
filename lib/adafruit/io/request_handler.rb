require 'open-uri'

module Adafruit
  module IO
    class RequestError < StandardError
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    module RequestHandler

      attr_reader :last_response, :pagination

      def request(method, url, data = nil, options = nil)
        @last_response = send(method, url, data)
      end

      def get(url, options = {})
        request(:handle_get, url, options)
      end

      def post(url, data, options = {})
        request :handle_post, url, data, options
      end

      def put(url, data, options = {})
        request :handle_put, url, data, options
      end

      def delete(url, options = {})
        request :handle_delete, url
      end

      def last_page?
        pagination.nil? || (pagination['limit'] != pagination['count'])
      end

      private

      def update_pagination(response)
        @pagination = nil

        if pagination_keys = response.headers.keys.grep(/x-pagination-/i)
          @pagination = {}
          pagination_keys.each do |k|
            @pagination[k.gsub(/x-pagination-/i, '')] = response.headers[k]
          end
        end
      end

      def parsed_response(response)
        if response.respond_to?(:data)
          response.data
        else
          begin
            json = JSON.parse(response.body)
          rescue => ex
            if @debug
              puts "ERROR PARSING JSON: #{ex.message}"
              puts ex.backtrace[0..5].join("\n")
            end
            response.body
          end
        end
      end

      def handle_get(url, options = {})
        response = conn.get do |req|
          req.url URI::encode(url)
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

      def handle_post(url, data, options = {})
        response = conn.post do |req|
          req.url URI::encode(url)
          req.body = data
        end

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("POST error: #{ response.body }", response)
        else
          parsed_response response
        end
      end

      def handle_put(url, data, options = {})
        response = conn.put do |req|
          req.url URI::encode(url)
          req.body = data
        end

        if response.status < 200 || response.status > 299
          raise Adafruit::IO::RequestError.new("PUT error: #{ response.body }", response)
        else
          parsed_response response
        end
      end

      def handle_delete(url, options = {})
        response = conn.delete do |req|
          req.url URI::encode(url)
        end

        if response.status < 200 || response.status > 299
          if response.status === 404
            nil
          else
            raise Adafruit::IO::RequestError.new("DELETE error: #{ response.body }", response)
          end
        else
          parsed_response response
        end
      end
    end
  end
end
