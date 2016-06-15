require 'json'
require 'rspec'
require 'dotenv'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start

require 'adafruit/io'

WebMock.disable_net_connect!(allow: 'io.adafruit.com')

Dotenv.load

MY_KEY    = ENV['ADAFRUIT_IO_KEY'].freeze
MY_KEY.nil? || MY_KEY.empty? and
      ($stderr.puts("No Key Found - cannot continue.") ; exit(1))

# NOTE: we should test with multiple feeds, but there's only 10 allowed
#       and so limiting to one.
#       ##TODO investigate making/getting a test account of some kind
FEED_NAME1 = 'test_feed_1'.freeze
FEED_DESC = 'My Test Feed Description'.freeze

DATA_NAME1 = 'test_data_1'.freeze
DATA_NAME2 = 'test_data_2'.freeze

GROUP_NAME1 = 'test_group_1'.freeze
GROUP_NAME2 = 'test_group_2'.freeze

DASHBOARD_NAME1 = 'test_dashboard_1'.freeze
DASHBOARD_NAME2 = 'test_dashboard_2'.freeze

$aio = nil

RSpec.describe 'initialization' do
  context 'starting with no feeds' do
    it 'found an IO key in the environment' do
      expect(MY_KEY).to be_a String
    end

    it 'can create a client using that key' do
      $aio = Adafruit::IO::Client.new key: MY_KEY
      expect($aio).to_not be_nil
    end
  end
end
