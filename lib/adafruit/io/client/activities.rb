module Adafruit
  module IO
    class Client
      module Activities

        # Get all dashboards.
        def activities(*args)
          username, _ = extract_username(args)
          get api_url(username, 'activities')
        end

        def delete_activities(*args)
          username, _ = extract_username(args)
          delete api_url(username, 'activities')
        end
      end
    end
  end
end


