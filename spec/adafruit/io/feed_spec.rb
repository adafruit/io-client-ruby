require 'helper'

# List of current properties associated with a feed.
FEED_PROPS_v1_0_2 = %w(
  id          key         name        description
  unit_symbol unit_type   last_value
  visibility  status      enabled
  created_at  updated_at  history     license
)

RSpec.describe Adafruit::IO::Feed do
  context 'starting with no feeds' do
    context '#retrieve with one argument' do
      it 'returns an error' do
        feed = $aio.feeds.retrieve FEED_NAME1

        ##TODO: really dislike this error check - it should raise an
        #       exception or have an error property or return (error, feed)
        #       or something similar
        #       (maybe config choice: raise or not as well)

        expect(feed).to respond_to :error
      end
    end

    ##TODO: need a test account to test with no feeds whatsoever

    context '#create' do
      it 'returns a new feed with the expected properties' do
        props = {}
        props['name'] = FEED_NAME1
        feed = $aio.feeds.create(props)

        expect(feed).not_to         respond_to :error
        expect(feed.name).to        eq FEED_NAME1
        expect(feed.values.keys.sort).to eq FEED_PROPS_v1_0_2.sort
      end
    end
  end

  context 'with a newly created feed,' do
    context '#retrieve, with no args' do
      it 'returns several feeds, with one containing the newly created feed' do
        feeds = $aio.feeds.retrieve

        feed = feeds.find { |f| f.name == FEED_NAME1 }

        expect(feed).not_to   be_nil
        expect(feed.name).to  eq FEED_NAME1
      end
    end

    context '#retrieve, with one arg' do
      it 'returns that feed' do
        feed = $aio.feeds.retrieve FEED_NAME1

        expect(feed.name).to eq FEED_NAME1
      end
    end

    describe '#save' do
      before(:example) do
        @feed = $aio.feeds.retrieve(FEED_NAME1)
      end

      it 'returns that feed' do
        expect(@feed.name).to         eq FEED_NAME1
        expect(@feed.description).to  be_nil
      end

      context 'updating the description' do
        it 'is returns the same feed' do
          @feed.description = FEED_DESC
          f = @feed.save

          expect(f.id).to eq @feed.id
        end

        it 'has the changed description' do
          expect(@feed.description).to eq FEED_DESC
        end
      end
    end

    context '#data, from a feed with no data' do
      it 'with no arguments, returns an object with no values' do
        feed = $aio.feeds.retrieve FEED_NAME1
        data = feed.data

        expect(data.values).to    eq({})
      end

      it 'with one argument, returns an object with no values' do
        feed = $aio.feeds.retrieve FEED_NAME1
        data = feed.data DATA_NAME1

        expect(data.values).to     eq({})
      end
    end

    context '#delete' do
      ## TODO: need to split this into two separate tests, but we need
      ## TODO:  the feed variable to stay in scope for both 'it' blocks
      it 'returns that feed and cannot be deleted again' do
        feed = $aio.feeds.retrieve FEED_NAME1
        expect(feed.name).to eq FEED_NAME1
        feed_id = feed.id

        result = feed.delete
        expect(result['delete']).to eq(true)
        expect(result['id']).to     eq feed_id

        result = feed.delete
        expect(result['delete']).to eq(false)
      end

      context '#retrieve for that feed' do
        it 'now returns an error' do
          feed = $aio.feeds.retrieve(FEED_NAME1)

          expect(feed).to respond_to(:error)
        end
      end
    end
  end
end
