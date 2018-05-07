require 'helper'

describe Adafruit::IO::Client do
  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  describe "configuration" do
    it "sets a valid key" do
      expect(@aio.key).to eq MY_KEY
    end

    it "sends the proper user agent" do
      stub_request(:get, URI::join(TEST_URL, "/api/test")).
        with(headers: {
          'User-Agent'=>"AdafruitIO-Ruby/#{ Adafruit::IO::VERSION } (#{ RUBY_PLATFORM })"
        }).
        to_return(:status => 200, :body => "", :headers => {})

      expect {
        @aio.get('/api/test')
      }.not_to raise_error
    end
  end
end
