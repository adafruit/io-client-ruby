module Adafruit
  module IO
    class Client
      module Triggers

        # Get all triggers.
        def triggers(*args)
          username, _ = extract_username(args)

          get api_url(username, 'triggers')
        end

        # Get a trigger specified by key
        def trigger(*args)
          username, arguments = extract_username(args)
          trigger_id = get_id_from_arguments(arguments)

          get api_url(username, 'triggers', trigger_id)
        end

        # Create a trigger. No attributes need to be passed in.
        def create_trigger(*args)
          username, arguments = extract_username(args)
          attrs = valid_trigger_attrs(arguments)

          post api_url(username, 'triggers'), attrs
        end

        def delete_trigger(*args)
          username, arguments = extract_username(args)
          trigger_id = get_id_from_arguments(arguments)

          delete api_url(username, 'triggers', trigger_id)
        end

        def update_trigger(*args)
          username, arguments = extract_username(args)
          trigger_id = get_id_from_arguments(arguments)
          attrs = valid_trigger_attrs(arguments)

          put api_url(username, 'triggers', trigger_id), attrs
        end

        private

        def valid_trigger_attrs(arguments)
          get_query_from_arguments(
            arguments,
            %w(feed_id operator value action to_feed_id action_feed_id
               action_value enabled trigger_type)
          )
        end

      end
    end
  end
end

