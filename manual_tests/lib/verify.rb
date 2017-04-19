#!/usr/bin/env ruby

##
# Module with verification helpers
#
# Handles HTTP REST or ruby library objects
#
# If accessing directly via HTTP REST, obj will be a hash
# otherwise, it's a class from the ruby libray, which has a hash
#   of all the properties.

module Verify

  ##
  # Handled expected outcome, including printing PASS/FAIL
  #
  # @yield  block containing the actual test, returning a boolean
  # @return true if failed
  #
  def expect(desc)
    b = yield

    leader = if (desc.nil? || desc.empty?)
               "#{@test_name}"
             else
               "\t\t#{desc}"
             end

    if b.nil?
      puts("#{leader}\tSKIP - #{@error}")
    elsif b
      puts("#{leader}\tPASS")
    else
      puts("#{leader}\tFAIL - #{@error}")
    end

    !b      # return true on failure
  end

  ##
  # Verify that the current object (@test_obj) has the specified properties
  #   and that the values match.
  def verify_against(props, list_key = nil)
    obj = obj_as_hash(@test_obj)
    return false if obj.nil?

    if list_key.nil?
      return _verify(obj, props, nil)
    end

    _verify(obj, props, list_key)
  end

protected

  ##
  # If the object is a Hash, return it (HTTP-direct API object).
  # Otherwise, build a hash from its getters (ruby library API object).
  def obj_as_hash(obj)
    return obj        if obj.is_a? Hash
    return obj.values if obj.respond_to? :values

    h = {}
    obj.methods(false).each do |m|
      next if m =~ /=/
      h[m.to_sym] = obj.send(m)
    end

    h
  end

  ##
  # Get a property from the object, regardless of where it came from.
  def _get_prop(obj, prop)
    obj = obj_as_hash(obj)
    if obj.nil?
      return nil
    end

    p = prop.to_sym
    p = prop.to_s unless obj.has_key?(p)
    return obj.has_key?(p) ? obj[p] : nil
  end

  ##
  # Get a property from the object, regardless of whence it came.
  def get_prop(obj, prop)
    val = _get_prop(obj, prop)
    if val.nil?
      $stderr.puts "#{@test_name} get_prop (#{prop}): " \
                                   "FAIL - unknown object: #{obj.inspect}"
      exit 1
    end

    val
  end

protected

  def _verify(obj, against_props, within_internal_list)
    failed = false
    against_props.each_pair do |key, expected|
      actual =  if within_internal_list.nil?
                  get_prop(obj, key)
                else
                  o = obj[within_internal_list].find { |i| i[:name] == key }
                  get_prop(o, :last_value)
                end

      if actual != expected
        fid = @test_obj.has_key?(:id) ? @test_obj[:id] : "unk"
        puts("\tFAIL (ID: #{fid} - #{key}: #{old} != expected #{expected})")
        failed = true
      end
    end

    expect("each_prop") { !failed }
  end

end
