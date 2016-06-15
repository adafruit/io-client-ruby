require 'helper'

# List of current properties associated with a feed.
FEED_PROPS_v1_0_2 = %w(
  id          key         name        description
  unit_symbol unit_type   last_value
  visibility  status      enabled
  created_at  updated_at  history     license
)

RSpec.describe Adafruit::IO::Feed do
  include_context "AdafruitIOv1"

  context 'starting with no feeds' do
    context '#retrieve with one argument' do
      it 'returns an error' do
        mock_response(
          path: "api/feeds/#{ FEED_NAME1 }",
          method: :get,
          status: 404,
          body: fixture_json('not_found_error'),
        )

        feed = $aio.feeds.retrieve FEED_NAME1
        expect(feed).to respond_to :error
      end
    end

    ##TODO: need a test account to test with no feeds whatsoever

    context '#create' do
      it 'returns a new feed with the expected properties' do
        mock_feed = mock_feed_record
        mock_response(
          path: "api/feeds",
          method: :post,
          status: 200,
          body: fixture_json('feed'),
        )

        feed = $aio.feeds.create(name: mock_feed['name'])

        expect(feed).not_to respond_to :error
        expect(feed.name).to eq mock_feed['name']
        expect(feed.values.keys.sort).to eq FEED_PROPS_v1_0_2.sort
      end
    end
  end

  context 'with a newly created feed,' do
    context '#retrieve, with no args' do
      it 'returns several feeds, with one containing the newly created feed' do
        mock_response(
          path: "api/feeds",
          method: :get,
          status: 200,
          body: JSON.generate([ mock_feed_record ]),
        )

        feeds = $aio.feeds.retrieve

        feed = feeds.find { |f| f.name == mock_feed_record['name'] }

        expect(feed).not_to  be_nil
        expect(feed.name).to eq mock_feed_record['name']
      end
    end

    context '#retrieve, with one arg' do
      it 'returns that feed' do
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )

        feed = $aio.feeds.retrieve mock_feed_record['key']

        expect(feed.name).to eq mock_feed_record['name']
      end
    end

    describe '#save' do
      before(:example) do
        @mock_record = mock_feed_record

        @updated_record = @mock_record.dup
        @updated_record['description'] = FEED_DESC
      end

      context 'updating the description' do
        it 'is returns the updated feed' do
          mock_response(
            path: "api/feeds/#{ @mock_record['key'] }",
            method: :get,
            status: 200,
            body: JSON.generate(@mock_record),
          )

          # GET ...
          @feed = $aio.feeds.retrieve(@mock_record['key'])

          mock_response(
            # .save generates path by ID
            path: "api/feeds/#{ @mock_record['id'] }",
            method: :put,
            status: 200,
            with_request_body: true,
            body: JSON.generate(@updated_record),
          )

          # ... then PUT
          @feed.description = FEED_DESC
          f = @feed.save

          expect(f.id).to eq @feed.id
          expect(f.description).to eq FEED_DESC
        end
      end
    end

    context '#data, from a feed with no data' do
      it 'with no arguments, returns an object with no values' do
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )

        feed = $aio.feeds.retrieve mock_feed_record['key']
        data = feed.data

        expect(data.values).to eq({})
      end

      it 'with one argument, returns an object with no values' do
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )

        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }/#{ DATA_NAME1 }",
          method: :get,
          status: 200,
          body: '{}',
        )

        feed = $aio.feeds.retrieve mock_feed_record['key']
        data = feed.data DATA_NAME1

        expect(data.values).to eq({})
      end
    end

    context '#delete' do
      ## TODO: need to split this into two separate tests, but we need
      ## TODO:  the feed variable to stay in scope for both 'it' blocks
      it 'returns that feed and cannot be deleted again' do
        mock_response(
          path: "api/feeds/#{ mock_feed_record['key'] }",
          method: :get,
          status: 200,
          body: mock_feed_json,
        )
        feed = $aio.feeds.retrieve mock_feed_record['key']

        expect(feed.name).to eq mock_feed_record['name']
        feed_id = feed.id

        mock_response(
          path: "api/feeds/#{ mock_feed_record['id'] }",
          method: :delete,
          status: 200
        )

        result = feed.delete
        expect(result['delete']).to eq(true)
        expect(result['id']).to     eq feed_id

        # subsequent requests get not found
        mock_response(
          path: "api/feeds/#{ mock_feed_record['id'] }",
          method: :delete,
          status: 404,
          body: fixture_json('not_found_error')
        )

        result = feed.delete
        expect(result['delete']).to eq(false)
      end

      context '#retrieve for that feed' do
        it 'now returns an error' do
          mock_response(
            path: "api/feeds/#{ mock_feed_record['key'] }",
            method: :get,
            status: 404,
            body: fixture_json('not_found_error')
          )

          feed = $aio.feeds.retrieve(mock_feed_record['key'])
          expect(feed).to respond_to(:error)
        end
      end
    end
  end
end
