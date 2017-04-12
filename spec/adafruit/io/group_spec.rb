require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  context 'starting with no feeds' do
    context '#feed with string key argument' do
      it 'returns nil' do
        mock_response(
          path: api_path('feeds', FEED_KEY1),
          method: :get,
          status: 404,
          body: fixture_json('not_found_error'),
        )

        feed = @aio.feed FEED_KEY1
        expect(feed).to be_nil
      end
    end

    context '#create' do
      it 'returns a new feed with the expected properties' do
        mock_feed = mock_feed_record

        mock_response(
          path: api_path('feeds'),
          method: :post,
          status: 200,
          body: fixture_json('feed'),
        )

        feed = @aio.create_feed(name: mock_feed['name'])

        expect(feed.keys).not_to include('error')
        expect(feed['name']).to eq mock_feed['name']
        expect(feed.keys.sort).to eq FEED_PROPS_v2_0_0.sort
      end
    end
  end

  context 'with a newly created feed,' do
    context '#feeds with no args' do
      it 'returns several feeds, with one containing the newly created feed' do
        mock_response(
          path: api_path('feeds'),
          method: :get,
          status: 200,
          body: JSON.generate([ mock_feed_record ]),
        )

        feeds = @aio.feeds

        feed = feeds.find { |f| f['name'] == mock_feed_record['name'] }

        expect(feed).not_to  be_nil
        expect(feed['name']).to eq mock_feed_record['name']
      end
    end

    context '#feed with one arg' do
      before do
        mock_response(
          path: api_path('feeds', mock_feed_record['key']),
          method: :get,
          status: 200,
          body: mock_feed_json,
        )
      end

      it 'returns that feed with string key' do
        feed = @aio.feed(mock_feed_record['key'])
        expect(feed['name']).to eq mock_feed_record['name']
      end

      it 'returns that feed with string-key hash' do
        feed = @aio.feed({'key' => mock_feed_record['key']})
        expect(feed['name']).to eq mock_feed_record['name']
      end

      it 'returns that feed with symbol-key hash' do
        feed = @aio.feed(key: mock_feed_record['key'])
        expect(feed['name']).to eq mock_feed_record['name']
      end
    end

    describe '#update_feed' do
      before(:example) do
        @mock_record = mock_feed_record

        @updated_record = @mock_record.dup
        @updated_record['description'] = FEED_DESC
      end

      context 'updating the description' do
        it 'returns the updated feed' do
          mock_response(
            path: api_path('feeds', @mock_record['key']),
            method: :put,
            status: 200,
            with_request_body: true,
            body: JSON.generate(@updated_record),
          )

          feed = @aio.update_feed(@mock_record['key'], description: @updated_record['description'])

          expect(feed['id']).to eq @mock_record['id']
          expect(feed['description']).to eq FEED_DESC
        end
      end
    end
  end
end
