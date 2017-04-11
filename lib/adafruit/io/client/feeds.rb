
module Adafruit
  module IO
    class Client
      module Feeds

        # Get all feeds.
        def feeds(*args)
          username, _ = extract_username(args)

          get api_url(username, 'feeds')
        end

        # Get a feed specified by key
        def feed(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          get api_url(username, 'feeds', feed_key)
        end

        # Get a feed along with additional details about the feed. This method
        # has more to lookup and so is slower than `feed`
        def feed_details(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          get api_url(username, 'feeds', feed_key, 'details')
        end

        def create_feed(*args)
          username, arguments = extract_username(args)
          feed_attrs = arguments.shift

          post api_url(username, 'feeds'), feed_attrs
        end

        def delete_feed(*args)
          username, arguments = extract_username(args)
          feed_key = get_key_from_arguments(arguments)

          delete api_url(username, 'feeds', feed_key)
        end

      end
    end
  end
end
