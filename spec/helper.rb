$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'json'
require 'rspec'
require 'webmock/rspec'

begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  warn 'warning: simplecov not found, skipping coverage'
end

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  warn 'warning: dotenv not found, please make sure env contains proper variables'
end

require 'adafruit/io'

# include all support files
Dir["./spec/support/**/*.rb"].each {|f| require f}

# isolate "normal" test suite from making calls to io.adafruit.com
WebMock.disable_net_connect!(allow_localhost: true)

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

$_fixture_json_files = {}
def fixture_json(file)
  if $_fixture_json_files[file].nil?
    $_fixture_json_files[file] = fixture(file + '.json').read
  end
  $_fixture_json_files[file].dup
end

MY_KEY = 'blah'.freeze

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
      # use test-only key
      $aio = Adafruit::IO::Client.new key: MY_KEY
      expect($aio).to_not be_nil
    end
  end
end
