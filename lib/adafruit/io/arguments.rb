module Adafruit
  module IO
    module Arguments
      class ArgumentError < StandardError; end

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

      # Allow users to pass a hash with key named 'key' or :key, or just a
      # plain string to use as a key.
      #
      #   client.feed({ key: 'myfeed' })
      #   client.feed({ 'key' => 'myfeed' })
      #   client.feed('myfeed')
      #
      # Are all equivalent.
      def get_key_from_arguments(arguments)
        record_or_key = arguments.shift
        return nil if record_or_key.nil?

        if record_or_key.is_a?(String)
          record_or_key
        elsif record_or_key.is_a?(Hash) && (record_or_key.has_key?('key') || record_or_key.has_key?(:key))
          record_or_key['key'] || record_or_key[:key]
        elsif record_or_key.respond_to?(:key)
          record_or_key.key
        else
          raise 'unrecognized object or key value in arguments'
        end
      end

      # Same as get_key_from_arguments but looking for id
      def get_id_from_arguments(arguments)
        record_or_id = arguments.shift
        return nil if record_or_id.nil?

        if record_or_id.is_a?(String) || record_or_id.is_a?(Fixnum)
          record_or_id
        elsif record_or_id.is_a?(Hash) && (record_or_id.has_key?('id') || record_or_id.has_key?(:id))
          record_or_id['id'] || record_or_id[:id]
        elsif record_or_id.respond_to?(:id)
          record_or_id.id
        else
          raise 'unrecognized object or id value in arguments'
        end
      end

      # Get a filtered list of parameters from the next argument
      def get_query_from_arguments(arguments, params)
        query = {}
        options = arguments.shift
        return query if options.nil?

        params.each do |param|
          query[param] = options[param.to_sym] if options.has_key?(param.to_sym)
        end
        query
      end

      def require_argument(arguments, argument_name)
        arg = arguments.first
        if !arg.is_a?(Hash)
          raise ArgumentError.new("This request requires arguments to be a Hash containing the key: :#{argument_name}")
        end

        if !(arg.has_key?(argument_name) || arg.has_key?(argument_name.to_s))
          raise ArgumentError.new("Missing required parameter, make sure to include #{argument_name}")
        end

        arg[argument_name] || arg[argument_name.to_s]
      end

    end
  end
end
