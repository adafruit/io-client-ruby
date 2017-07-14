module Adafruit
  module IO
    class Client
      module Blocks

        # Get all blocks for a dashboard. Requires dashboard_key.
        def blocks(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)

          get api_url(username, 'dashboards', dashboard_key, 'blocks')
        end

        # Get a block specified by ID
        def block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_id = get_id_from_arguments(arguments)

          get api_url(username, 'dashboards', dashboard_key, 'blocks', block_id)
        end

        def create_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_attrs = arguments.shift

          post api_url(username, 'groups'), group_attrs
        end

        def delete_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_id = get_id_from_arguments(arguments)

          delete api_url(username, 'dashboards', dashboard_key, 'blocks', block_id)
        end

        def update_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_id = get_id_from_arguments(arguments)

          query = get_query_from_arguments(arguments, %w(name properties visual_type column row size_x size_y block_feeds))

          put api_url(username, 'dashboards', dashboard_key, 'blocks', block_id), query
        end

      end
    end
  end
end

