require 'hashie'
require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'
require 'json'
require 'adafruit/io/client/feed'
require 'adafruit/io/client/groups'
require 'adafruit/io/client/data'
require 'adafruit/io/client/request_handler'

module Adafruit
  module IO
    class Client

      include Adafruit::IO::Client::Data
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

      def put(url, data, options = {})
        request :handle_put, url, data, options
      end

      def delete(url, options = {})
        request :handle_delete, url
      end

      def last_response
        @last_response
      end

      def feeds(id_or_key = nil)
        feeds = Adafruit::IO::Feed.new(self, id_or_key)

        return feeds
      end

  private 

      def conn
        connection = Faraday.new(:url => 'http://localhost:3002') do |c|
        #connection = Faraday.new(:url => 'https://io.adafruit.com') do |c|
          c.headers['X-AIO-Key'] = @key
          c.headers['Accept'] = 'application/json'
          c.request :json

          c.response :xml,  :content_type => /\bxml$/
          #c.response :mashify, :content_type => /\bjson$/
          #c.response :json

          c.use :instrumentation
          c.adapter Faraday.default_adapter
        end
      end

      def request(method, url, data = nil, options = nil)
        @last_response = response = send(method, url, data)
      end


    end
  end
end