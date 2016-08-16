require 'helper'

describe Adafruit::IO::Client do

  describe "configuration" do
    it "sets a valid key" do
      client = Adafruit::IO::Client.new :key => "random_key"
      expect(client.instance_variable_get(:"@key")).to eq "random_key"
    end

    it "sends the proper user agent" do
      stub_request(:get, URI::join(TEST_URL, "/api/test")).
        with(headers: {
          'User-Agent'=>"AdafruitIO-Ruby/#{ Adafruit::IO::VERSION } (#{ RUBY_PLATFORM })"
        }).
        to_return(:status => 200, :body => "", :headers => {})

      client = Adafruit::IO::Client.new :key => 'test'
      expect {
        client.get('test')
      }.not_to raise_error
    end
  end
end
