require 'helper'

RSpec.describe Adafruit::IO::Feed do
  include_context "AdafruitIOv1"

  context 'with a feed having data' do
    context '#retrieve' do
      it 'with no arguments, returns feed data' do
        # get Feed
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )
        feed = $aio.feeds.retrieve mock_feed_record['key']

        # get Data
        mock_response(
          path: "api/feeds/#{ mock_feed_record['id'] }/data",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = feed.data.retrieve

        expect(data.size).to eq(3)
      end

      it 'accepts params' do
        # get FEED
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )

        feed = $aio.feeds.retrieve mock_feed_record['key']

        # get DATA
        mock_response(
          path: "api/feeds/#{ mock_feed_record['id'] }/data?end_time=2001-01-01&start_time=2000-01-01",
          method: :get,
          status: 200,
          body: mock_data_json,
        )
        data = feed.data.retrieve(nil, start_time: '2000-01-01', end_time: '2001-01-01')

        expect(data.size).to eq(3)
      end
    end
  end
end
