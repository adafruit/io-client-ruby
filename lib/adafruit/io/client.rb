require 'hashie'
require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'
require 'json'
require 'adafruit/io/client/feeds'
require 'adafruit/io/client/outputs'
require 'adafruit/io/client/inputs'
require 'adafruit/io/client/request_handler'

module Adafruit
  module IO
    class Client

      include Adafruit::IO::Client::Feeds
      include Adafruit::IO::Client::Outputs
      include Adafruit::IO::Client::Inputs
      include Adafruit::IO::Client::RequestHandler

      def initialize(options)
        @key = options[:key]
      end

      def get(url, options = {})
        request :handle_get, url
      end

      def post(url, data, options = {})
        request :handle_post, url, data, options
      end

      def put(url, options = {})
        request :handle_put, url
      end      

      def last_response
        @last_response
      end

  private 

      def conn
        conn = Faraday.new(:url => 'http://localhost:3002') do |conn|
          conn.headers['X-Api-Key'] = @key
          conn.headers['Accept'] = 'application/json'
          conn.request :json

          conn.response :xml,  :content_type => /\bxml$/
          conn.response :mashify, :content_type => /\bjson$/
          conn.response :json

          conn.use :instrumentation
          conn.adapter Faraday.default_adapter
        end
      end

      def request(method, url, data = nil, options = nil)
        @last_response = response = send(method, url, data)
      end


    end
  end
end