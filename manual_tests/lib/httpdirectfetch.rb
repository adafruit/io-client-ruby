#!/usr/bin/env ruby

# Special case return data / cases -- using constants to call out/document them
# - The framework expects consistent returns namely [ success_bool, JSON ]
#   where the JSON is data or { error: error_description_string }
GET_NONEXIST_DATA_RETURNS_JSON  = true
GET_NONEXIST_GROUP_RETURNS_JSON = true
DELETE_RETURNS_NOTHING          = true

require 'faraday'
require 'faraday_middleware'          # for c.request :json
require 'json'

require 'dotenv'
Dotenv.load

ADAFRUIT_IO_KEY = ENV['ADAFRUIT_IO_KEY'].freeze
ADAFRUIT_IO_KEY.nil? || ADAFRUIT_IO_KEY.empty? and
                                      ( $stderr.puts("No Key Found") ; exit(1))

require 'common'
require 'verify'
require 'testobject'

# https://io.adafruit.com/api/docs

BaseURL     = "https://io.adafruit.com/api"   # /feeds.csv, /feeds/1.xml, etc.
APIVersion  = "1.1.0"

#-------------------------------------------------------------------------------

# Module for accessing https://Adafruit.io via its HTTP REST API

module HTTPDirectFetch

  ##
  # Handle an error condition
  #
  # @return an error description string
  def handle_error(status, body)

    if status == 401 || status == 403    # Unauthorized
      $stderr.puts "\nInvalid Key -- cannot continue, exiting... (#{status})\n\n"
      exit(status)
    end

    if status == 500 && ERROR_500_NOT_JSON
      # Comes back as plain text
      body = "{ \"error\"   : \"#{body.lines[0].join('; ')}\" }"
    end

    begin
      json = JSON.parse(body, :symbolize_names => true)
    rescue => e
      $stderr.puts "==============\nbody: "
      ap body
      $stderr.puts "exception: "
      ap e
      $stderr.puts "==============\n\n"
      raise
    end

    json[:error] = "Unspecified error" unless json.has_key? :error

    @error = json[:error]
    return json
  end

  ##
  # Invoke the HTTP request and return the response
  #
  def _invoke(op, url_path, payload = nil)

    @@conn ||= Faraday.new(:url => BaseURL) do |c|
        c.headers['X-AIO-Key'] = ADAFRUIT_IO_KEY
        c.headers['Accept'] = 'application/json'
        c.request :json
        c.adapter Faraday.default_adapter
    end

    response = @@conn.send(op) do |req|
      req.url URI::encode(url_path)
      req.body = JSON.dump(payload) if payload
    end

    response
  end

  #-----------------------------------------------------------------------------
  ##
  # The framework expects consistent return values, so handle them here
  # Handle return of empty JSON
  #
  # @return [ bool, JSON_str ] ; bool indicates success
  #         if false (error case), JSON_str is { error: error_str } as a string
  #         (called before converting response.body, so JSON str)
  def handle_empty_body(response, op, url_path)

    # Deleting something returns nothing - http code indicates success
    if op == :delete && DELETE_RETURNS_NOTHING
      body = "{ \"deleted\" : \"#{response.success?}\" }"
      return [ response.status, body ]
    end

    body = "{ \"error\" : \"empty body\" }"
    return [ 400, body ]
  end

  #-----------------------------------------------------------------------------
  ##
  # The framework expects consistent return values, so handle them here
  # Handle other special cases
  #
  # @return [ bool, JSON_obj ] ; bool indicates success
  #         if false (error case), JSON_obj is { error: error_str }
  #         (called after converting response.body, so JSON object)
  def is_special_case(response, op, url_path, json)

    # If the data item doesn't exist, it returns
    #       { }
    if op == :get && GET_NONEXIST_DATA_RETURNS_JSON && url_path =~ /feed/
      return nil unless json.is_a?(Hash)

      if json.empty? || (json.has_key?(:error) && json[:error] =~ /not found/)
        @error = { error: "ENOEXIST" }
        return [ false, @error ]
      end
    end

    # If the group doesn't exist, it returns
    #       { :feeds => { :last_stream => {} } }
    # instead of
    #       404 Not Found (or ala Feed: empty JSON)
    #
    if op == :get && GET_NONEXIST_GROUP_RETURNS_JSON && url_path =~ /group/
      return nil unless json.is_a?(Hash)

      unless json.has_key?(:name)
        @error = { error: "ENOEXIST" }
        return [ false, @error ]
      end
      return nil
    end

    return nil
  end

  #-----------------------------------------------------------------------------
  ##
  # Common method for invoking an HTTP REST call
  #
  # @param op         The HTTP verb (i.e. get, post, put, patch, delete)
  # @param url_path   The path to the resource (e.g. /api/feeds/)
  # @param payload    Only required if verb calls for it.
  #
  # @return [ http_status_code: Integer, json: JSON ]
  # if http_status_code indicates and error, the json will be the error string
  #
  def invoke(op, url_path, payload = nil)
    response = _invoke(op, url_path, payload)

    body = response.body
    status = response.status

    if body.empty?
      status, body = handle_empty_body(response, op, url_path)
    end

    unless status < 400
      err_json = handle_error(status, body)        # can throw

      return [ false, err_json ]
    end

    begin
      json = JSON.parse(body, :symbolize_names => true)
    rescue => e
      $stderr.puts "==============\nbody: "
      ap response.body
      $stderr.puts "exception: "
      ap e
      $stderr.puts "==============\n\n"
      raise
    end

    ret = is_special_case(response, op, url_path, json)
    return ret unless ret.nil?

    [ true, json ]
  end

  # Convenience method to get an object or get all objects
  #
  # @returns [ success?, json_body ]
  def base_get(url_path)                                # GET
    invoke(:get, url_path)
  end

  # Convenience method to create an object
  #
  # @returns [ success?, json_body ]
  def base_post(url_path, payload)                      # POST
    invoke(:post, url_path, payload)
  end

  # Convenience method to delete an object
  #
  # @returns [ success?, json_body ]
  def base_delete(url_path)                             # DELETE
    invoke(:delete, url_path)
  end

  # Convenience method to update (patch) properties of an object
  #
  # @returns [ success?, json_body ]
  def base_patch(url_path, payload)                     # PATCH
    invoke(:patch, url_path, payload)
  end

  # Convenience method to replace an entire object
  #
  # @returns [ success?, json_body ]
  def base_put(url_path, payload)                       # PUT
    invoke(:put, url_path, payload)
  end

  # Create an object outside the tests - used to init the starting case
  #
  # @returns [ success?, json_body ]
  def non_test_get(url_path)                                # GET
    invoke(:get, url_path)
  end

  # Delete an object outside the tests - used to init the starting case
  #
  # @returns [ success?, json_body ]
  def non_test_delete(url_path)                             # DELETE
    invoke(:delete, url_path)
  end

  #-----------------------------------------------------------------------------
  ##
  # Methods called by the testing framework (TestObject)
  #
  def do_test_create()
    base_post("#{@obj_path}/", @prop_sets[:create])
  end

  def do_test_get_all()
    base_get("#{@obj_path}/")
  end

  def do_test_get_one(id)
    base_get("#{@obj_path}/#{id}")
  end

  def do_test_update()
    base_patch("#{@obj_path}/#{@created_id}", @prop_sets[:update])
  end

  def do_test_replace()
    base_put("#{@obj_path}/#{@created_id}", @prop_sets[:replace])
  end

  def do_test_delete()
    base_delete("#{@obj_path}/#{@created_id}")
  end

  #-----------------------------------------------------------------------------
  ##
  # Code coverage not applicable
  def do_test_code_coverage_feed
  end

  def do_test_code_coverage_group
  end

  def do_test_code_coverage_data
  end

  #-----------------------------------------------------------------------------
  ##
  # Ensure a clean starting state
  #  - queries and deletes all objects that we create
  def ensure_starting_state()

    delete_all = ->(path, names) do
      ok, all_objs = non_test_get("#{path}")
      return unless ok

      all_objs.each do |obj|
        obj_name = get_prop(obj, :name)
        next unless names.any? { |n| n == obj_name }

        id = get_prop(obj, :id)
        return if id.nil?

        ok, all_objs = non_test_delete("#{path}/#{id}")
      end
    end

    delete_all.call("feeds",  TEST_FEED_NAMES)
    delete_all.call("groups", TEST_GROUP_NAMES)
  end

  #-----------------------------------------------------------------------------
  ##
  # Data tests require a feed, so these methods create/delete feeds without
  #   going through the standard feed test path.
  def non_test_create_data_feed()
    ok, feed = invoke(:post, "feeds/", @payload)

    unless ok        # Intentionally avoiding PASS message
      $stderr.puts "create test data feed #{@payload[:name]} -> #{ok}"
      return
    end

    @feed_id = get_prop(feed, :id).to_s
    @obj_path.sub!("_FEEDID_", @feed_id)
  end

  def non_test_delete_data_feed()
    ok, _ = invoke(:delete, "feeds/#{@feed_id}")
    $stderr.puts "delete test data feed #{@payload[:name]} -> #{ok}" unless ok
  end
end
