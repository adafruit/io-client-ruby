require 'uri'

module Adafruit
  module IO
    class Client
      module Groups
        def send_group(group_name, data)
          if group_name
            group_name = URI::escape(group_name)
            post "groups/#{group_name}/send", {:value => data}
          else

          end
        end

        def receive_group(group_name)
          if group_name
            group_name = URI::escape(group_name)
            get "feeds/#{group_name}/last", {:value => data}
          else

          end
        end

        def receive_next_group(group_name)
          if group_name
            group_name = URI::escape(group_name)
            get "feeds/#{group_name}/next", {:value => data}
          else

          end
        end        

        def groups(feed_id_or_key, output_id=nil, options = {})
          if input_id
            get "groups/#{feed_id_or_key}/#{input_id}", options
          else
            get "groups/#{feed_id_or_key}", options
          end
        end

        def create_group(feed_id_or_key, options = {})       
          post "groups/#{feed_id_or_key}", options
        end
      end
    end
  end
end