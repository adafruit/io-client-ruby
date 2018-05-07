module Adafruit
  module IO
    module Configurable

      # Client configuration variables
      attr_accessor :key, :username

      # Client configuration variables with defaults
      attr_writer :api_endpoint

      def api_endpoint
        if @api_endpoint.nil?
          'https://io.adafruit.com'
        else
          @api_endpoint
        end
      end

    end
  end
end

