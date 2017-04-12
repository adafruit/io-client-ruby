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
          path: "api/v2/test_username/feeds/#{ mock_feed_record['key'] }/data",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = @aio.data mock_feed_record

        expect(data.size).to eq(3)
      end

      it 'accepts params' do
        # get DATA
        mock_response(
          path: "api/v2/test_username/feeds/#{ mock_feed_record['key'] }/data?end_time=2001-01-01&start_time=2000-01-01",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = @aio.data(mock_feed_record, start_time: '2000-01-01', end_time: '2001-01-01')

        expect(data.size).to eq(3)
      end
    end
  end
end
