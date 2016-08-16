require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'
require 'json'
require 'adafruit/io/client/feed'
require 'adafruit/io/client/group'
require 'adafruit/io/client/data'
require 'adafruit/io/client/request_handler'

module Adafruit
  module IO
    class Client

      include Adafruit::IO::Client::RequestHandler

      def initialize(options)
        @key = options[:key]
      end

      def get(url, options = {})
        request :handle_get, url, options
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
        Adafruit::IO::Feed.new(self, id_or_key)
      end

      def groups(id_or_key = nil)
        Adafruit::IO::Group.new(self, id_or_key)
      end

      def data(feed_id_or_key = nil, id_or_key = nil)
        Adafruit::IO::Data.new(self, feed_id_or_key, id_or_key)
      end

  private

      def conn
        #Faraday.new(:url => 'http://localhost:3002') do |c|
        if ENV['ADAFRUIT_IO_URL']
          url = ENV['ADAFRUIT_IO_URL']
        else
          url = 'https://io.adafruit.com'
        end

        Faraday.new(:url => url) do |c|
          c.headers['X-AIO-Key'] = @key
          c.headers['Accept'] = 'application/json'
          c.headers['User-Agent'] = "AdafruitIO-Ruby/#{VERSION} (#{RUBY_PLATFORM})"
          c.request :json

          c.response :xml,  :content_type => /\bxml$/
          #c.response :mashify, :content_type => /\bjson$/
          #c.response :json

          c.use :instrumentation
          c.adapter Faraday.default_adapter
        end
      end

      def request(method, url, data = nil, options = nil)
        @last_response = send(method, url, data)
      end
    end
  end
end
