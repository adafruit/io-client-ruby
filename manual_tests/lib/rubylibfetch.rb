#!/usr/bin/env ruby

# Special case return data / cases -- using constants to call out/document them
# - The framework expects consistent returns namely [ success_bool, JSON ]
#   where the JSON is data or { error: error_description_string }
GET_NONEXIST_DATA_RETURNS_JSON  = true
GET_NONEXIST_GROUP_RETURNS_JUNK = true

require 'dotenv'
Dotenv.load

ADAFRUIT_IO_KEY = ENV['ADAFRUIT_IO_KEY'].freeze
ADAFRUIT_IO_KEY.nil? || ADAFRUIT_IO_KEY.empty? and
                                      ( $stderr.puts("No Key Found") ; exit(1))

require 'common'
require 'verify'
require 'testobject'

require 'simplecov'
SimpleCov.start
SimpleCov.command_name "test:library"

require 'adafruit/io'

AIO = Adafruit::IO::Client.new :key => ENV['ADAFRUIT_IO_KEY'].freeze

#-------------------------------------------------------------------------------
# Module for accessing https://Adafruit.io via its ruby library

module RubyLibFetch

  #-----------------------------------------------------------------------------
  ##
  # The framework expects consistent return values, so handle them here
  # Handle sucess special cases
  #
  # @return [ bool, JSON_obj ] ; bool indicates success
  #         if false (error case), JSON_obj is { error: error_str }
  #         (called after converting response.body, so JSON object)
  def is_special_case_success(obj)
    return nil if obj.is_a?(Array)

    # If the group doesn't exist, it returns
    #       { :feeds => { :last_stream => {} } }
    # instead of
    #       404 Not Found
    #
    if GET_NONEXIST_GROUP_RETURNS_JUNK && @obj_name == "groups"
      unless obj.respond_to?(:name)
        @error = { error: "ENOEXIST" }
        return [ false, obj ]
      end

      return nil
    end

    # If the data item doesn't exist, it returns
    #       { }
    if GET_NONEXIST_DATA_RETURNS_JSON && @obj_name == "data"
      unless obj.respond_to?(:value)
        @error = { error: "ENOEXIST" }
        return [ false, obj ]
      end

      return nil
    end

    return nil
  end

  def process_result(obj)

    if obj.respond_to?(:error)
      @error = obj.error
      return [ false, obj.error ]
    end

    ret = is_special_case_success(obj)
    return ret unless ret.nil?

    [ true, obj ]
  end

  def process_del_result(obj, id)
    ok = (obj == {"delete" => true, "id" => id })
    @error = obj unless ok
    [ ok, nil ]
  end

  #=============================================================================
  ##
  # Methods called by the testing framework (TestObject)
  #
  def do_test_create()
    case @obj_name
    when "feeds"
      return process_result(AIO.feeds.create(@prop_sets[:create]))
    when "groups"
      return process_result(AIO.groups.create(@prop_sets[:create]))
    when "data"
      return process_result(@feed.data.create(@prop_sets[:create]))
    end

    $stderr.puts "Unknown object: #{@obj_name}"
    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_get_all()
    case @obj_name
    when "feeds"
      return process_result(AIO.feeds.retrieve)
    when "groups"
      return process_result(AIO.groups.retrieve)
    when "data"
      return process_result(@feed.data.retrieve)
    end

    $stderr.puts "Unknown object: #{@obj_name}"
    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_get_one(id_key_name)
    case @obj_name
    when "feeds"
      return process_result(AIO.feeds.retrieve(id_key_name))
    when "groups"
      return process_result(AIO.groups.retrieve(id_key_name))
    when "data"
      return process_result(@feed.data.retrieve(id_key_name))
    end

    $stderr.puts "Unknown object: #{@obj_name}"
    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_update()
    @error = "Library API doesn't support REST PATCH verb"
    # NOTE: the library acts more like a PATCH (update) than a PUT (replace)
    return [ nil, @test_obj ]

#    @prop_sets[:update].each { |k, v| @test_obj.send(k, v) }
#
#    case @obj_name
#    when "feeds"
#      return process_result(AIO.feeds.save)
#    when "groups"
#      return process_result(AIO.groups.save)
#    when "data"
#      return process_result(@feed.data.save)
#    end
#    $stderr.puts "Unknown object: #{@obj_name}"
#    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_replace()
    # NOTE: the library acts more like a PATCH (update) than a PUT (replace)

    @prop_sets[:replace].each { |k, v| @test_obj.send("#{k}=".to_s, v) }

    case @obj_name
    when "feeds"
      return process_result(@test_obj.save)
    when "groups"
      return process_result(@test_obj.save)
    when "data"
      return process_result(@test_obj.save)
    end

    $stderr.puts "Unknown object: #{@obj_name}"
    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_delete()
    id = @test_obj.id

    case @obj_name
    when "feeds"
      return process_del_result(@test_obj.delete, id)
    when "groups"
      return process_del_result(@test_obj.delete, id)
    when "data"
      return process_del_result(@test_obj.delete, id)
    end

    $stderr.puts "Unknown object: #{@obj_name}"
    [ false, { error: "ENOIMPL" } ]
  end

  def do_test_code_coverage_feed
    ok, _obj = process_result(AIO.feeds.retrieve(24601))
    expect("Invalid feed") { !ok }
  end

  def do_test_code_coverage_group
    ok, _obj = process_result(AIO.groups.retrieve(24601))
    expect("Invalid group") { !ok }

    ## NOTE: there are others, but they are all undocumented in
    #         https://io.adafruit.com/api/docs/#!/Groups/all
    #         (and many are broken) -- 160616
  end

  def do_test_code_coverage_data
    prev =  @prop_sets[:replace]["value"]

    ok, obj = process_result(@feed.data.create({ "value" => "foo" }))
    expect("Data#create") { ok && obj.respond_to?(:value) && obj.value == "foo" }

    ok, obj = process_result(@feed.data.last)
    expect("Data#last") { ok && obj.respond_to?(:value) && obj.value == "foo" }

    ok, obj = process_result(@feed.data.previous)
    expect("Data#previous") { ok && obj.respond_to?(:value) && obj.value == "foo" }

    ok, obj = process_result(@feed.data.next)
    expect("Data#next") { ok && obj.respond_to?(:value) && obj.value == prev }

    ##TODO: needs library fixes
    #ok, obj = process_result(AIO.feeds("test_feed2").data.send_data("24601"))
    #expect("Data#send_data") { ok && obj.respond_to?(:value) && obj.value == "24601" }
  end

  #-----------------------------------------------------------------------------
  ##
  # Ensure a clean starting state
  #  - queries and deletes all objects that we create
  def ensure_starting_state()

    delete_all = ->(path, names) do
      all_objs = AIO.send(path).retrieve
      return unless all_objs.is_a? Array

      all_objs.each do |obj|
        obj_name = obj.name
        next unless names.any? { |n| n == obj_name }

        h = obj.delete
        _ok = h.is_a?(Hash) && h["delete"]
      end
    end

    delete_all.call(:feeds,  TEST_FEED_NAMES)
    delete_all.call(:groups, TEST_GROUP_NAMES)
  end

  #-----------------------------------------------------------------------------
  ##
  # Data tests require a feed, so these methods create/delete feeds without
  #   going through the standard feed test path.
  def non_test_create_data_feed()
    @feed = AIO.feeds.create(@payload)
    @feed_id = @feed.id.to_s
    @obj_path.sub!("_FEEDID_", @feed_id)
    $stderr.puts "create test data feed #{@payload[:name]} -> #{!@feed.respond_to?(:error)}"
  end

  def non_test_delete_data_feed()
    h = @feed.delete
    ok = h["delete"]
    $stderr.puts "delete test data feed #{@payload[:name]} -> #{ok}" unless ok
  end
end
