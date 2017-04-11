module Adafruit
  module IO
    class Client
      module Data

        # Add data to a feed.
        #
        # Params:
        #   - feed_key: string
        #   - value: string or number
        #   - location (optional): {lat: Number, lon: Number, ele: Number}
        #   - created_at (optional): iso8601 date time string.
        #
        def send_data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)
          value = arguments.shift

          attrs = {
            value: value
          }

          if arguments.size > 0 && arguments.first.is_a?(Hash)
            location = arguments.shift
            if location[:lat] && location[:lon]
              attrs[:lat] = location[:lat]
              attrs[:lon] = location[:lon]
              attrs[:ele] = location[:ele]
            end
          end

          if arguments.size > 0
            if arguments.first.is_a?(String)
              created_at = arguments.shift
              attrs[:created_at] = created_at
            elsif arguments.first.is_a?(Time)
              created_at = arguments.shift
              attrs[:created_at] = created_at.utc.iso8601
            end
          end

          post api_url(username, 'feeds', feed_key, 'data'), attrs
        end

        # Send a batch of data points.
        #
        # Points can either be a list of strings, numbers, or hashes with the
        # keys [ value, created_at OPTIONAL, lat OPTIONAL, lon OPTIONAL, ele OPTIONAL ]
        #
        def send_batch_data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)
          values = arguments.shift

          if values.nil? || !values.is_a?(Array)
            raise "expected batch values to be an array"
          end

          if !values.first.is_a?(Hash)
            # convert values to hashes with single key: 'value'
            values = values.map {|val| {value: val}}
          end

          post api_url(username, 'feeds', feed_key, 'data', 'batch'), data: values
        end

        # Get all data for a feed, may paginate.
        def data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)
          query = get_query_from_arguments arguments, %w(start_time end_time limit)

          get api_url(username, 'feeds', feed_key, 'data'), query
        end

        # Get charting data for a feed.
        def data_chart(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)
          query = get_query_from_arguments arguments, %w(start_time end_time limit hours resolution)

          get api_url(username, 'feeds', feed_key, 'data', 'chart'), query
        end

        # Get a single data point.
        def datum(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)
          data_id = arguments.shift

          get api_url(username, 'feeds', feed_key, 'data', data_id)
        end

        # Retrieve the next unprocessed data point.
        def next_data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          get api_url(username, 'feeds', feed_key, 'data', 'next')
        end

        # Retrieve the previously processed data point. This method does not
        # move the stream pointer.
        def prev_data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          get api_url(username, 'feeds', feed_key, 'data', 'prev')
        end

        # Move the stream processing pointer to and retrieve the last (newest)
        # data point available.
        def last_data(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          get api_url(username, 'feeds', feed_key, 'data', 'last')
        end

      end
    end
  end
end
