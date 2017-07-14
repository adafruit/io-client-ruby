require 'helper'

# List of current properties associated with a feed.
FEED_PROPS_v2_0_0 = %w(
     created_at   description     group            groups        history
     id           key             last_value       license       name
     owner        status_notify   status_timeout   unit_symbol
     unit_type    updated_at      username
     visibility
)

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
        mock_response(
          path: api_path('feeds'),
          method: :post,
          status: 200,
          body: mock_feed_json,
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
      it 'returns the newly created feed' do
        mock_response(
          path: api_path('feeds'),
          method: :get,
          status: 200,
          body: JSON.generate([ mock_feed ]),
        )

        feeds = @aio.feeds

        feed = feeds.find { |f| f['name'] == mock_feed['name'] }

        expect(feed).not_to  be_nil
        expect(feed['name']).to eq mock_feed['name']
      end
    end

    context '#feed with one arg' do
      before do
        mock_response(
          path: api_path('feeds', mock_feed['key']),
          method: :get,
          status: 200,
          body: mock_feed_json,
        )
      end

      it 'returns that feed when given string key' do
        feed = @aio.feed(mock_feed['key'])
        expect(feed['name']).to eq mock_feed['name']
      end

      it 'returns that feed when given string-key hash' do
        feed = @aio.feed({'key' => mock_feed['key']})
        expect(feed['name']).to eq mock_feed['name']
      end

      it 'returns that feed when given symbol-key hash' do
        feed = @aio.feed(key: mock_feed['key'])
        expect(feed['name']).to eq mock_feed['name']
      end
    end

    describe '#update_feed' do
      before(:example) do
        @mock_record = mock_feed

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

    context '#delete' do

      it 'returns deleted feed' do
        mock_response(
          path: api_path('feeds', mock_feed['key']),
          method: :delete,
          status: 200,
          body: fixture_json('feed')
        )

        result = @aio.delete_feed(mock_feed['key'])
        expect(result['id']).to eq mock_feed['id']
      end

      it "raises not found when feed doesn't exist" do
        mock_response(
          path: api_path('feeds', mock_feed['key']),
          method: :delete,
          status: 404,
          body: fixture_json('not_found_error'),
        )

        expect(@aio.delete_feed(mock_feed['key'])).to be_nil
      end

    end
  end
end
