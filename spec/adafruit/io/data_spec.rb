require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  context 'with a feed having data' do
    context 'data' do
      it 'returns feed data' do
        # get Data
        mock_response(
          path: "api/v2/test_username/feeds/#{ mock_feed['key'] }/data",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = @aio.data mock_feed

        expect(data.size).to eq(3)
      end

      it 'accepts params' do
        # get DATA
        mock_response(
          path: "api/v2/test_username/feeds/#{ mock_feed['key'] }/data?end_time=2001-01-01&start_time=2000-01-01",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = @aio.data(mock_feed, start_time: '2000-01-01', end_time: '2001-01-01')

        expect(data.size).to eq(3)
      end
    end

    context 'send_data' do
      it 'sends a Time created_at as utc iso8601' do
        created_at = Time.new(2026, 1, 2, 3, 4, 5, '-05:00')
        request = stub_request(:post, URI.join(TEST_URL, "/#{api_path('feeds', 'f', 'data')}"))
          .with(body: { value: 1, created_at: '2026-01-02T08:04:05Z' }.to_json)
          .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

        @aio.send_data('f', 1, created_at)

        expect(request).to have_been_requested
      end
    end
  end
end
