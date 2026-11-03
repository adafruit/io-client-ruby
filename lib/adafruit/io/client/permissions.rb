module Adafruit
  module IO
    class Client
      module Permissions
        VALID_TYPES = %w(feed group dashboard).freeze

        # Get all permissions for a resource.
        #
        #   client.permissions(TYPE, KEY)
        def permissions(*args)
          username, arguments = extract_username(args)

          assert_argument_size(arguments, 2)
          assert_resource_type(arguments[0])

          get api_url(username, pluralize_type(arguments[0]), arguments[1], 'acl')
        end

        def permission(*args)
          username, arguments = extract_username(args)

          assert_argument_size(arguments, 3)
          assert_resource_type(arguments[0])

          get api_url(username, pluralize_type(arguments[0]), arguments[1], 'acl', arguments[2])
        end

        #   client.create_permission(TYPE, KEY, { scope: 'public', mode: 'r' })
        def create_permission(*args)
          username, arguments = extract_username(args)

          assert_argument_size(arguments, 2)
          assert_resource_type(arguments[0])

          permission_attrs = arguments[2]
          if !permission_attrs.is_a?(Hash)
            raise Adafruit::IO::Arguments::ArgumentError.new('create_permission requires resource type (string), resource key (string), and a Hash of permission attributes, e.g. { scope: "public", mode: "r" }')
          end

          post api_url(username, pluralize_type(arguments[0]), arguments[1], 'acl'), permission_attrs
        end

        def delete_permission(*args)
          username, arguments = extract_username(args)

          assert_argument_size(arguments, 3)
          assert_resource_type(arguments[0])

          delete api_url(username, pluralize_type(arguments[0]), arguments[1], 'acl', arguments[2])
        end

        private

        def assert_resource_type(resource_type)
          if !VALID_TYPES.include?(resource_type)
            raise Adafruit::IO::Arguments::ArgumentError.new('permission resource type must be one of: feed, group, or dashboard')
          end
        end

        def assert_argument_size(arguments, size)
          if size === 3
            if arguments.size < 3
              raise Adafruit::IO::Arguments::ArgumentError.new('permission requires resource type (string), key (string), and permission id (integer) values. valid types are feeds, groups, or dashboards')
            end
          elsif size == 2
            if arguments.size < size
              raise Adafruit::IO::Arguments::ArgumentError.new('permissions requires resource type (string) and resource key (string) values. valid types are feed, group, or dashboard')
            end
          end
        end

        def pluralize_type(resource_type)
          "#{resource_type}s"
        end
      end
    end
  end
end


