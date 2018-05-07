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
          block_id = get_key_from_arguments(arguments)

          get api_url(username, 'dashboards', dashboard_key, 'blocks', block_id)
        end

        # Create a block
        def create_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_attrs = valid_block_attrs(arguments)

          post api_url(username, 'dashboards', dashboard_key, 'blocks'), block_attrs
        end

        # Delete a block
        def delete_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_id = get_key_from_arguments(arguments)

          delete api_url(username, 'dashboards', dashboard_key, 'blocks', block_id)
        end

        # Update a block
        def update_block(*args)
          username, arguments = extract_username(args)
          dashboard_key = require_argument(arguments, :dashboard_key)
          block_id = get_key_from_arguments(arguments)
          block_attrs = valid_block_attrs(arguments)

          put api_url(username, 'dashboards', dashboard_key, 'blocks', block_id), block_attrs
        end

        # The list of every valid property name that can be stored by Adafruit IO.
        #
        # Not every property applies to every block. Boolean values should be
        # stored as the string "yes" or "no".
        def valid_block_properties
          %w(
            text value release fontSize onText offText backgroundColor onColor
            offColor min max step label orientation handle minValue maxValue
            ringWidth label xAxisLabel yAxisLabel yAxisMin yAxisMax tile
            fontColor showName showTimestamp errors historyHours showNumbers
            showLocation
          )
        end

        # The list of every valid block type that can be presented by Adafruit IO.
        def valid_block_visual_types
          %w(
            toggle_button slider momentary_button gauge line_chart text
            color_picker map stream image remote_control
          )
        end

        private

        def valid_block_attrs(arguments)
          get_query_from_arguments(
            arguments,
            %w(name properties visual_type column row size_x size_y block_feeds)
          )
        end
      end
    end
  end
end

