
module Adafruit
  module IO
    class Client
      module User

        # Get user associated with the current key. If this method returns nil
        # it means you have a bad key.
        def user(*args)
          get '/api/v2/user'
        end

      end
    end
  end
end

