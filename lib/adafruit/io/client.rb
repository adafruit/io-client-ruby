require 'json'

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'

require 'adafruit/io/arguments'
require 'adafruit/io/configurable'
require 'adafruit/io/request_handler'

require 'adafruit/io/client/feeds'
require 'adafruit/io/client/data'
require 'adafruit/io/client/groups'
require 'adafruit/io/client/tokens'
require 'adafruit/io/client/user'

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
      include Adafruit::IO::Client::Tokens
      include Adafruit::IO::Client::User

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
        safe_path_join *['api', 'v2', username].concat(args)
      end

      # safely build URL paths from segments
      def safe_path_join(*paths)
        paths = paths.compact.map(&:to_s).reject(&:empty?)
        last = paths.length - 1
        paths.each_with_index.map { |path, index|
          safe_path_expand(path, index, last)
        }.join
      end

      def safe_path_expand(path, current, last)
        if path[0] === '/' && current != 0
          path = path[1..-1]
        end

        unless path[-1] === '/' || current == last
          path = [path, '/']
        end

        path
      end

    end
  end
end
