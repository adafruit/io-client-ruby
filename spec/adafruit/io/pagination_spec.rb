require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  def stub_feeds(headers = {})
    stub_request(:get, URI.join(TEST_URL, "/#{api_path('feeds')}"))
      .to_return(status: 200, body: "[#{mock_feed_json}]", headers: headers)
  end

  describe '#last_page?' do
    it 'is true when the response has no pagination headers' do
      stub_feeds
      @aio.feeds

      expect(@aio.pagination).to be_nil
      expect(@aio.last_page?).to be true
    end

    it 'is true when count is less than limit' do
      stub_feeds('X-Pagination-Limit' => '1000', 'X-Pagination-Count' => '1')
      @aio.feeds

      expect(@aio.pagination).to include('limit' => '1000', 'count' => '1')
      expect(@aio.last_page?).to be true
    end

    it 'is false when count equals limit' do
      stub_feeds('X-Pagination-Limit' => '1000', 'X-Pagination-Count' => '1000')
      @aio.feeds

      expect(@aio.last_page?).to be false
    end

    it 'resets after a non-GET request' do
      stub_feeds('X-Pagination-Limit' => '1000', 'X-Pagination-Count' => '1000')
      stub_request(:post, URI.join(TEST_URL, "/#{api_path('feeds')}")).to_return(status: 200, body: mock_feed_json)

      @aio.feeds
      @aio.create_feed(name: 'x')

      expect(@aio.pagination).to be_nil
      expect(@aio.last_page?).to be true
    end
  end
end
