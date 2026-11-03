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

  describe "#inspect" do
    it "shows username and endpoint with a masked key" do
      client = Adafruit::IO::Client.new(key: 'abcdefghijkl', username: 'test_username')

      expect(client.inspect).to eq(
        '#<Adafruit::IO::Client username="test_username" api_endpoint="https://io.adafruit.com" key="abcd********">'
      )
    end

    it "fully masks short keys" do
      expect(Adafruit::IO::Client.new(key: 'abc').inspect).to include('key="***"')
    end

    it "does not include the connection after a request" do
      stub_request(:get, /api\/test/).to_return(status: 200, body: "")
      client = Adafruit::IO::Client.new(key: 'abcdefghijkl', username: 'test_username')
      client.get('/api/test')

      expect(client.inspect).not_to include('abcdefghijkl')
      expect(client.inspect).not_to include('Faraday')
    end
  end

  describe "connection" do
    before do
      stub_request(:get, /io\.adafruit\.test|other\.test/).to_return(status: 200, body: "")
    end

    it "reuses the connection across requests" do
      expect(Faraday).to receive(:new).once.and_call_original

      @aio.get('/api/test')
      @aio.get('/api/test')
    end

    it "rebuilds the connection when the key changes" do
      @aio.get('/api/test')
      @aio.key = 'new-key'
      @aio.get('/api/test')

      expect(a_request(:get, /api\/test/).with(headers: { 'X-AIO-Key' => 'new-key' })).to have_been_made.once
    end

    it "rebuilds the connection when the endpoint changes" do
      @aio.get('/api/test')
      @aio.api_endpoint = 'http://other.test'
      @aio.get('/api/test')

      expect(a_request(:get, 'http://other.test/api/test')).to have_been_made.once
    end
  end
end
