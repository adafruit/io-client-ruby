#!/usr/bin/env ruby

##
# Framework for testing the Adafruit IO remote API
#
#  It can test either the HTTP REST API (via Faraday HTTP gem) or the ruby
#     API library interface.
#
#  Only tests the basics of the API - i.e. that each is minimally available
#  For example, it
#   - does not extensively test setting properties of an object
#   - does not test various formats - just JSON
#   - does not test multiple objects - e.g. just that find all returns an array
#
#   The tests covers API version 1.1.1
#   The tests will provide 100% code coverage.
#     The tests cover all API of Feed and Group.
#     The tests cover all of Data, except:          (as of 160612) TODO
#
#  GET     => "/feeds/f_idkn/data/receive",  # Receive data?
#  GET     => "/feeds/f_idkn/data/previous", # Previous Data in Queue
#  GET     => "/feeds/f_idkn/data/next",     # Next     Data in Queue
#  GET     => "/feeds/f_idkn/data/last",     # Last     Data in Queue
#
#  POST    => "/feeds/f_idkn/data",          # Create new data item
#  POST    => "/feeds/f_idkn/data/send",     # Create new feed AND data item

require "testobjectdata"

##
# TestObject for testing a Feed or a Group
#
class TestObject
  include Verify

  ##
  # Create a test object for a specific object or no object
  #
  # @param prop_sets  if nil, then TestObject's purpose is to ensure a clean
  #                     starting state.  Otherwise, it is a hash that specifies
  #                     the object specifics (i.e. the feed/group/data object
  #                     properties)
  def initialize(prop_sets = nil)
    return if prop_sets.nil?                      ## TODO move ensure* to another class

    @obj_name     = prop_sets[:name]
    @obj_path     = prop_sets[:path]
    @prop_sets    = prop_sets

    @created_id   = nil
    @created_obj  = nil
    @test_obj     = nil

    @test_name    = nil
    @error        = nil
  end

  ##
  #
  # Run the entire suite - expects a clean state
  # (i.e. no existing test feed or group)
  def run()
    if @created_obj.nil?
      return if test_create().nil?
    end

    test_get_all
    test_key_id_name
    test_update
    test_replace

    case @obj_name
    when 'feeds'  then test_code_coverage_feed
    when 'groups' then test_code_coverage_group
    when 'data'   then test_code_coverage_data
    else puts "Unknown object '@obj_name' for code coverage - ignoring.."
    end

    test_delete
    test_deleted

    puts "- #{@obj_name} DONE"
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 1 - Create a feed/group/data item
  def test_create()
    @test_name = "test_#{@obj_name}: create:      "
    @error     = nil

    ok, obj = do_test_create
    return nil if expect("") { ok }

    @test_obj = obj
    if verify_against(@prop_sets[:create])
      @test_obj = nil
      return nil
    end

    @created_id = get_prop(obj, :id)
    @created_obj = obj

    # Convert to string - for code coverage
    s = @test_obj.to_s

    expect("to_s\t") { !s.empty? }
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 2 - Get all objects and ensure the newly created object is there
  def test_get_all()
    @test_name = "test_#{@obj_name}: get_all:     "
    @error     = nil

    ok, all_objs = do_test_get_all
    return if expect("get_all\t") { ok }

    @test_obj = all_objs.find { |o| get_prop(o, :id) == @created_id }
    return if expect("") { ! @test_obj.nil? }

    verify_against(@prop_sets[:create])
  end

  def fetch_via(desc, key)
    ok, @test_obj = do_test_get_one(key)
    return if expect(desc + "\t") { ok }

    verify_against(@prop_sets[:create])
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 3 - Fetch that object by each of id/key/name
  def test_key_id_name()
    base_test_name = "test_#{@obj_name}: get via"
    @error         = nil

    %i( id name key ).each do | k |

      key = get_prop(@created_obj, k)         # i.e. data item only has ID
      next if key.nil?

      @test_name = "#{base_test_name} #{k.to_s.upcase}: "

      fetch_via(k.to_s, key)
    end
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 4 - Update a single property within that object
  def test_update()
    @test_name = "test_#{@obj_name}: update:      "
    @error     = nil

    ok, @test_obj = do_test_update
    return if expect("") { ok }

    verify_against(@prop_sets[:update])
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 5 - Replace the entire object with another
  def test_replace()
    @test_name = "test_#{@obj_name}: replace:     "
    @error     = nil

    ok, @test_obj = do_test_replace
    return if expect("") { ok }

    verify_against(@prop_sets[:replace])
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 6 - Delete the object
  def test_delete()
    @test_name = "test_#{@obj_name}: delete:      "
    @error     = nil

    ok, _obj = do_test_delete

    expect("") { ok }

    # Failure case - for code coverage -- delete again should fail
    ok, _obj = do_test_delete
    expect("delete deleted") { !ok }

  end

  #-----------------------------------------------------------------------------
  ##
  # Test 7 - Verify that it no longer exists
  def test_deleted()
    @test_name = "test_#{@obj_name}: deleted:      "
    @error     = nil

    ok, _obj = do_test_get_one(@created_id)

    expect("") { !ok }
  end

  #-----------------------------------------------------------------------------
  ##
  # Test 8a - Code Coverage specific Feed tests
  def test_code_coverage_feed()
    @test_name = "test_code_coverage_#{@obj_name}:"
    @error     = nil

    do_test_code_coverage_feed
    expect("") { true }
  end

  ##
  # Test 8b - Code Coverage specific Group tests
  def test_code_coverage_group()
    @test_name = "test_code_coverage_#{@obj_name}:"
    @error     = nil

    do_test_code_coverage_group
    expect("") { true }
  end

  ##
  # Test 8c - Code Coverage specific Data tests
  def test_code_coverage_data
    @test_name = "test_code_coverage_#{@obj_name}:"
    @error     = nil

    do_test_code_coverage_data
    expect("") { true }
  end

  #-----------------------------------------------------------------------------
  ##
  # If an existing object exists, get it - useful (and only used) if debugging
  #
  # @return true if found
  def get_existing()
    names = if @obj_name == "feeds"
              TEST_FEED_NAMES
            else
              TEST_GROUP_NAMES
            end

    obj = nil
    names.each do |n|
      ok, obj = base_get("#{@obj_path}/#{n}")
      break if ok
      obj = nil
    end
    return false if obj.nil?

    @created_id = get_prop(obj, :id)
    @created_obj = obj
    @test_obj = obj
    true
  end

end

################################################################################

##
# TestObject for testing a Data item
#   Data requires a feed and hence this is pretty much just a wrapper around
#     the above TestObject which creates a feed, calls the TestObject#run
#     method and then deletes the feed.
#
class TestDataObject < TestObject
  def initialize(prop_sets)                               # overrides
    super(prop_sets)
    @payload = LIST_OF_PROP_SETS[:feeds][:create]
  end

  def run()                               # overrides
    non_test_create_data_feed()

    super

    non_test_delete_data_feed()
  end

protected

  def test_key_id_name()                  # overrides
    # Data has only an ID key, so cleaner to just override it.
    @test_name = "test_#{@obj_name}: get via id\t"

    old = @obj_path
    @obj_path = "#{@obj_path.sub("_FEEDID_", @feed_id)}/"

    fetch_via("id", @created_id)

    @obj_path = old
  end

end

################################################################################

##
# Convenience method to run all the tests for all the objects.
#
# This is the (only) entry point to the tests.
def run_all
  puts "Setting up.."
  TestObject.new().ensure_starting_state
  puts " - done"

  LIST_OF_PROP_SETS.each do |_key, lops|

    begin
      lops[:ctor].call(lops).run
      puts ""
    rescue => e
      puts "### Exception caught ###"
      puts e
      puts e.backtrace
      puts "### continuing.. ###"
    end
  end
end
