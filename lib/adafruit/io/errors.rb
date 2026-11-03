module Adafruit
  module IO
    class Error < StandardError; end

    class RequestError < Error
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    module Arguments
      class ArgumentError < Adafruit::IO::Error; end
    end
  end
end
