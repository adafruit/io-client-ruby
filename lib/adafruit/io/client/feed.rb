require 'uri'
require 'adafruit/io/client'
require 'active_model'
require 'active_support/core_ext/object/instance_variables'

module Adafruit
  module IO

    class Feed
      attr_accessor :unsaved_values

      def initialize(client = nil, id_or_key = nil)
        @client = client
        @id_or_key = id_or_key
        @unsaved_values = Set.new
        @values = {}
      end

      def create(options = {})       
        response = @client.post 'feeds', options
        return process_response(response)
      end

      def retrieve(id_or_key = nil, options = {})
        if id_or_key
          @id_or_key = id_or_key
          response = @client.get "feeds/#{id_or_key}", options
        else
          response = @client.get 'feeds', options
        end

        return process_response(response)
      end

      def update

      end

      def delete

      end

      def save
        response = @client.put "feeds/#{self.id}", serialize_params(self)
        @unsaved_values.clear

        return process_response(response)
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
            obj_list.push(Feed.new(@client, @id_or_key).parse(r))
          end
        else
          obj_list = Feed.new(@client, @id_or_key).parse(response)
        end

        return obj_list
      end

      def parse(o)
        o.each do |k, v|
          singleton_class.class_eval do; attr_accessor_with_changes "#{k}"; end
          send("#{k}=", v)
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