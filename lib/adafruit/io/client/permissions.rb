module Adafruit
  module IO
    class Client
      module Permissions

        # Get all permissions for a resource.
        #
        #   client.permissions(TYPE, KEY)
        def permissions(*args)
          username, arguments = extract_username(args)

          if arguments.size < 2
            raise 'permissions requires model type (string) and model key (string) values. valid types are feeds, groups, or dashboards'
          end

          get api_url(username, arguments[0], arguments[1], 'acl')
        end

        def permission(*args)
          username, arguments = extract_username(args)

          if arguments.size < 3
            raise 'permission requires model type (string), model key (string), and id (integer) values. valid types are feeds, groups, or dashboards'
          end

          get api_url(username, arguments[0], arguments[1], 'acl', arguments[2])
        end

        def create_permission(*args)
          username, arguments = extract_username(args)
          if arguments.size < 3
            raise 'permission requires model type (string), model key (string), and id (integer) values. valid types are feeds, groups, or dashboards'
          end
          permission_attrs = arguments.pop
          post api_url(username, arguments[0], arguments[1], 'acl'), permission_attrs
        end

        def delete_permission(*args)
          username, arguments = extract_username(args)

          if arguments.size < 3
            raise 'permission requires model type (string), key (string), and id (integer) values. valid types are feeds, groups, or dashboards'
          end

          delete api_url(username, arguments[0], arguments[1], 'acl', arguments[2])
        end
      end
    end
  end
end


