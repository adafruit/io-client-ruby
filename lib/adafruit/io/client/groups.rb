module Adafruit
  module IO
    class Client
      module Groups

        # Get all groups.
        def groups(*args)
          username, _ = extract_username(args)

          get api_url(username, 'groups')
        end

        # Get a group specified by key
        def group(*args)
          username, arguments = extract_username(args)
          group_key = get_key_from_arguments(arguments)

          get api_url(username, 'groups', group_key)
        end

        def group_add_feed(*args)
          username, arguments = extract_username(args)
          group_key = get_key_from_arguments(arguments)
          feed_key = get_key_from_arguments(arguments)

          post api_url(username, 'groups', group_key, 'add'), feed_key: feed_key
        end

        def group_remove_feed(*args)
          username, arguments = extract_username(args)
          group_key = get_key_from_arguments(arguments)
          feed_key = get_key_from_arguments(arguments)

          post api_url(username, 'groups', group_key, 'remove'), feed_key: feed_key
        end

        def create_group(*args)
          username, arguments = extract_username(args)
          group_attrs = arguments.shift

          post api_url(username, 'groups'), group_attrs
        end

        def delete_group(*args)
          username, arguments = extract_username(args)
          group_key = get_key_from_arguments(arguments)

          delete api_url(username, 'groups', group_key)
        end

        def update_group(*args)
          username, arguments = extract_username(args)
          group_key = get_key_from_arguments(arguments)
          query = get_query_from_arguments(arguments, %w(name key))

          put api_url(username, 'groups', group_key), query
        end

      end
    end
  end
end

