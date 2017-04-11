require 'json'
require 'uri'

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/response/mashify'

require 'adafruit/io/configurable'
require 'adafruit/io/request_handler'

require 'adafruit/io/client/feeds'
require 'adafruit/io/client/data'

# require 'adafruit/io/client/group'

module Adafruit
  module IO
    class Client

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

      # Allows us to give a username during client initialization or with a specific method.
      def extract_username(args)
        username = @username

        if args.last.is_a?(Hash) && args.last.has_key?(:username)
          username = args.last.delete(:username)
        end

        if username.nil?
          raise "cannot make request when username is nil"
        end

        [ username, args ]
      end

      def get_key_from_arguments(arguments)
        record_or_key = arguments.shift
        return nil if record_or_key.nil?

        if record_or_key.is_a?(String)
          record_or_key
        elsif record_or_key.is_a?(Hash) && record_or_key.has_key?('key')
          record_or_key['key']
        elsif record_or_key.is_a?(Hash) && record_or_key.has_key?(:key)
          record_or_key[:key]
        elsif record_or_key.respond_to?(:key)
          record_or_key.key
        else
          raise 'unrecognized object or key value in arguments'
        end
      end

      def get_query_from_arguments(arguments, params)
        query = {}
        options = arguments.shift
        return query if options.nil?

        params.each do |param|
          query[param] = options[param.to_sym] if options.has_key?(param.to_sym)
        end
        query
      end

      def api_url(username, *args)
        to_join = ['api', 'v2', username].concat(args)

        File.join(*to_join)
      end
    end
  end
end
