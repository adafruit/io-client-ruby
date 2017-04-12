require 'json'
require 'uri'

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'

require 'adafruit/io/arguments'
require 'adafruit/io/configurable'
require 'adafruit/io/request_handler'

require 'adafruit/io/client/feeds'
require 'adafruit/io/client/data'
require 'adafruit/io/client/groups'

module Adafruit
  module IO
    class Client

      include Adafruit::IO::Arguments
      include Adafruit::IO::Configurable
      include Adafruit::IO::RequestHandler

      def initialize(options)
        @key = options[:key]
        @username = options[:username]

        @debug = !!options[:debug]
      end

      # Text representation of the client, masking key
      #
      # @return [String]
      def inspect
        inspected = super
        inspected = inspected.gsub! @key, "#{@key[0..3]}#{'*' * (@key.size - 3)}" if @key
        inspected
      end

      def last_response
        @last_response
      end

      include Adafruit::IO::Client::Feeds
      include Adafruit::IO::Client::Data
      include Adafruit::IO::Client::Groups

      private

      def conn
        if api_endpoint
          url = api_endpoint
        else
          url = 'https://io.adafruit.com'
        end

        Faraday.new(:url => url) do |c|
          c.headers['X-AIO-Key'] = @key
          c.headers['Accept'] = 'application/json'
          c.headers['User-Agent'] = "AdafruitIO-Ruby/#{VERSION} (#{RUBY_PLATFORM})"
          c.request :json

          # if @debug is true, Faraday will get really noisy when making requests
          if @debug
            c.response :logger
          end

          c.use :instrumentation
          c.adapter Faraday.default_adapter
        end
      end

      def api_url(username, *args)
        to_join = ['api', 'v2', username].concat(args)

        File.join(*to_join)
      end
    end
  end
end
