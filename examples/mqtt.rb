# Example script using MQTT to access adafruit.io
# - Nicholas Humfrey has an excellent MQTT library, which is very easy to use.

begin
  require 'mqtt'        # gem install mqtt ;  https://github.com/njh/ruby-mqtt
rescue LoadError
  fatal 'The mqtt gem is missing ; try the following command: gem install mqtt'
end

################################################################################
# Usage:
#   Subscribe:
#       ./mqtt.rb   # with no arguments subscribes to all feeds and print any
#                     and all values that are published.
#
#       ./mqtt.rb   # with 1 argument subscribes to a particular feed, following
#                     the MQTT topic specification (e.g. myname/#)
#
#                     NOTE: if a feed is fully specified (e.g. without a topic
#                       wildcard: + or #) only the value is returned. Otherwise,
#                       other properties are returned as well - see below.
#
#   Publish:
#       ./mqtt.rb feed value [ feed value ... ]
#                   - publish each value to the associated feed
#                   - requires PAIRs of args
#
#                   NOTE: the value MUST be a single value unless one of the
#                           following is done:
#                           a) Append '/csv' to the feed, or
#                           b) Set the environment variable 'ADAFRUIT_FORMAT'
#                                 to 'csv' (which just auto-appends '/csv' to
#                                 the feed name.
#                           - If either of those is done, then value can be:
#
#                               VALUE,latitude,longitude,elevation
#
#                         OTHERWISE the value will be interpreted as a
#                             single value - i.e. a string of, for example,
#                             value "42,0,0,0".
# --
#
# Example:
#
#   # In one command-line window:
#       ADAFRUIT_FORMAT=csv ./mqtt.rb my_temperature_feed
#
#   # In another command-line window:
#       ./mqtt.rb my_temperature_feed/csv 42,47.62,-122.35,113
#
#   # You should see the above numbers appear on the original screen
#
################################################################################

ADAFRUIT_THROTTLE_PUBLISHES_PER_SECOND = 2     # limit to N requests per second

# ---
# Define MQTT config, mostly from the environment, for connecting to Adafruit

begin
  require 'dotenv'      # If a .env file is present, it will be loaded
  Dotenv.load           #   into the environment, which is a handy way to do it.
rescue LoadError
  warn 'Warning: dotenv not found - make sure ENV contains proper variables'
end

# Required
ADAFRUIT_USER   = ENV['ADAFRUIT_USER'].freeze
ADAFRUIT_IO_KEY = ENV['ADAFRUIT_IO_KEY'].freeze

# Optional
ADAFRUIT_HOST   = (ENV['ADAFRUIT_HOST'] || 'io.adafruit.com').freeze
ADAFRUIT_PORT   = (ENV['ADAFRUIT_PORT'] || 1883).freeze

ADAFRUIT_FORMAT = ENV['ADAFRUIT_FORMAT'].freeze

# ---
# Allow filtering to a specific format

#ADAFRUIT_DOCUMENTED_FORMATS = %w( csv json xml ).freeze
                                      # Adafruit-MQTT doesn't support XML 160619
ADAFRUIT_MQTT_FORMATS       = %w( csv json ).freeze

FORMAT_REGEX_PATTERN        = %r{/(csv|json)$}

FILTER_FORMAT = if ADAFRUIT_FORMAT.nil?
                  nil
                elsif ADAFRUIT_MQTT_FORMATS.include?(ADAFRUIT_FORMAT)
                  "/#{ADAFRUIT_FORMAT}".freeze
                else
                  $stderr.puts("Unsupported format (#{ADAFRUIT_FORMAT})")
                  exit 1
                end

ADAFRUIT_CONNECT_INFO = {
  username: ADAFRUIT_USER,
  password: ADAFRUIT_IO_KEY,
  host:     ADAFRUIT_HOST,
  port:     ADAFRUIT_PORT
}.freeze

################################################################################
# Publish
# Connect, then for each pair of args, send the second arg to the first.

if ARGV.length > 1
  MQTT::Client.connect(ADAFRUIT_CONNECT_INFO) do |client|
    break if ARGV.length < 2

    feed  = ARGV.shift
    value = ARGV.shift.dup        # arg is frozen and MQTT wants to force encode

    topic = if ADAFRUIT_FORMAT.nil? || feed.end_with?(ADAFRUIT_FORMAT)
              "#{ADAFRUIT_USER}/f/#{feed}"
            else
              "#{ADAFRUIT_USER}/f/#{feed}/#{ADAFRUIT_FORMAT}"
            end

    $stderr.puts "Publishing #{value} to #{topic} @ #{ADAFRUIT_HOST}"

    client.publish(topic, value)

    sleep(1.0 / ADAFRUIT_THROTTLE_PUBLISHES_PER_SECOND)
  end

  exit 0
end

################################################################################
# Subscribe
# Connect and for each event received, print the associated value (as desired)
#   - never returns

TOPIC = if ARGV.empty?
          "#{ADAFRUIT_USER}/f/#"
        else
          "#{ADAFRUIT_USER}/f/#{ARGV[0]}"
        end

$stderr.puts "Connecting to #{ADAFRUIT_HOST} as #{ADAFRUIT_USER} for #{TOPIC}"

MQTT::Client.connect(ADAFRUIT_CONNECT_INFO).connect do |client|
  client.get(TOPIC) do |feed, value|
    #
    # Print if  a) no format specified,
    #           b) it matches the specified format, or
    #           c) the topic doesn't have a format.
    #
    #  - For the latter, if you subscribe to a particular feed, it just
    #     sends the value without any format or additional properties.
    #       e.g. 99.02
    #
    #  - Otherwise, it appends the format to the topic and sends the value
    #     along with the other properties.
    #     - Those properties depend on the format:
    #
    #       currently, 160619:
    #
    #         CSV:  VALUE,latitude,longitude,elevation
    #             e.g. 99.02,null,null,null
    #
    #         JSON: The entire server object, including internal/read-only
    #               properties (too many to list here).

    next unless FILTER_FORMAT.nil? || (feed =~ FORMAT_REGEX_PATTERN).nil? ||
                FILTER_FORMAT == $&
    puts "#{feed}: #{value}"
  end
end
# (auto-disconnects when #connect is given a block)

exit 0
