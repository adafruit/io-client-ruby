module Adafruit
  module IO
    class Client
      module Tokens

        # Get all tokens.
        def tokens(*args)
          username, _ = extract_username(args)

          get api_url(username, 'tokens')
        end

        # Get a token specified by key
        def token(*args)
          username, arguments = extract_username(args)
          token_id = get_id_from_arguments(arguments)

          get api_url(username, 'tokens', token_id)
        end

        # Create a token. No attributes need to be passed in.
        def create_token(*args)
          username, arguments = extract_username(args)

          post api_url(username, 'tokens')
        end

        def delete_token(*args)
          username, arguments = extract_username(args)
          token_id = get_id_from_arguments(arguments)

          delete api_url(username, 'tokens', token_id)
        end

      end
    end
  end
end

