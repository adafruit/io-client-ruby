require 'uri'
require 'adafruit/io/client'
require 'adafruit/io/client/io_object'
require 'active_model'
require 'active_support/core_ext/object/instance_variables'

module Adafruit
  module IO
    class IOObject
      attr_accessor :unsaved_values, :id_or_key, :attr_list

      def initialize(client = nil, id_or_key = nil)
        @client = client
        @id_or_key = id_or_key
        @unsaved_values = Set.new
        @values = {}
        @attr_list = Set.new
      end

      protected
        #serialize_params derived from stripe-ruby library, MIT License, Copyright (c) 2011- Stripe, Inc. (https://stripe.com)
        #https://github.com/stripe/stripe-ruby/blob/9cf5089dc15534b7ed581e0ce4d84fa82f592efb/lib/stripe/api_operations/update.rb#L37
        def serialize_params(obj)
          return '' if obj.nil?

          unsaved_keys = obj.instance_variable_get(:@unsaved_values)
          obj_values = obj.instance_variable_get(:@values)
          update_hash = {}

          unsaved_keys.each do |k|
            update_hash[k] = obj_values[k]
          end

          update_hash
        end

        def process_response(response)
          response = JSON.parse(response, :symbolize_names => true)

          if response.is_a?(Array)
            obj_list = []
            response.each do |r|
              if @feed.present?
                obj_list.push(self.class.new(@client, @feed, @id_or_key).parse(r))
              else
                obj_list.push(self.class.new(@client, @id_or_key).parse(r))
              end
            end
          else
            if @feed.present?
              obj_list = self.class.new(@client, @feed, @id_or_key).parse(response)
            else
              obj_list = self.class.new(@client, @id_or_key).parse(response)
            end
          end

          return obj_list
        end

        def parse(o)
          o.each do |k, v|
            singleton_class.class_eval do; attr_accessor_with_changes "#{k}"; end
            send("#{k}=", v)
            @attr_list << k
            @unsaved_values.delete(k.to_s)
          end

          return self
        end

        def self.attr_accessor_with_changes(attr_name)
          attr_name = attr_name.to_s
       
          #getter
          self.class_eval("def #{attr_name};@#{attr_name};end")
       
          #setter
          self.class_eval %Q{
            def #{attr_name}=(val)
              key = __callee__.to_s.chomp("=")
              @unsaved_values.add(key)
              @values[key] = val
              @#{attr_name} = val
            end
          }
       
        end
    end
  end
end
