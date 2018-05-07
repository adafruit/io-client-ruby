module Adafruit
  module IO
    class Client
      module Dashboards

        # Get all dashboards.
        def dashboards(*args)
          username, _ = extract_username(args)

          get api_url(username, 'dashboards')
        end

        # Get a dashboard specified by key
        def dashboard(*args)
          username, arguments = extract_username(args)
          dashboard_key = get_key_from_arguments(arguments)

          get api_url(username, 'dashboards', dashboard_key)
        end

        # Create a dashboard. No attributes need to be passed in.
        def create_dashboard(*args)
          username, arguments = extract_username(args)
          attrs = arguments.shift

          post api_url(username, 'dashboards'), attrs
        end

        def delete_dashboard(*args)
          username, arguments = extract_username(args)
          dashboard_key = get_key_from_arguments(arguments)

          delete api_url(username, 'dashboards', dashboard_key)
        end

        def update_dashboard(*args)
          username, arguments = extract_username(args)
          dashboard_key = get_key_from_arguments(arguments)
          query = get_query_from_arguments(arguments, %w(name key))

          put api_url(username, 'dashboards', dashboard_key), query
        end

        def update_dashboard_layouts(*args)
          username, arguments = extract_username(args)
          dashboard_key = get_key_from_arguments(arguments)
          query = get_query_from_arguments(arguments, %w(layouts))

          post api_url(username, 'dashboards', dashboard_key, 'update_layouts'), query
        end
      end
    end
  end
end


