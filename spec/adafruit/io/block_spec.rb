require 'helper'

# valid block properties

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns blocks' do
    mock_response(
      path: api_path('dashboards', 'db', 'blocks'),
      method: :get,
      status: 200,
      body: "[#{mock_block_json}]",
    )

    blocks = @aio.blocks(dashboard_key: 'db')
    expect(blocks).not_to be_empty
  end

  it 'returns a block' do
    mock_response(
      path: api_path('dashboards', 'db', 'blocks', 1),
      method: :get,
      status: 200,
      body: mock_block_json,
    )

    block = @aio.block(dashboard_key: 'db', key: 1)
    expect(block).not_to be_empty
  end

  it 'creates a new block' do
    mock_response(
      path: api_path('dashboards', 'db', 'blocks'),
      method: :post,
      status: 200,
      body: mock_block_json,
    )

    block = @aio.create_block({
      dashboard_key: 'db',
      block: {
        name: "block",
        properties: { },
        visual_type: "color",
        column: 0,
        row: 0,
        size_x: 0,
        size_y: 0,
        block_feeds: [{
          feed_id: "1",
          group_id: "1"
        }]
      }
    })
    expect(block).not_to be_empty
  end

  it 'deletes a block' do
    mock_response(
      path: api_path('dashboards', 'db', 'blocks', 1),
      method: :delete,
      status: 200,
      body: mock_block_json
    )

    result = @aio.delete_block(key: 1, dashboard_key: 'db')
    expect(result['key']).to eq mock_block['key']
  end

  it 'updates a block' do
    mock_record = mock_block
    updated_record = mock_record.dup
    updated_record['name'] = "new name"


    mock_response(
      path: api_path('dashboards', 'db', 'blocks', 1),
      method: :put,
      status: 200,
      with_request_body: true,
      body: JSON.generate(updated_record)
    )

    result = @aio.update_block(key: 1, dashboard_key: 'db')
    expect(result['key']).to eq updated_record['key']
    expect(result['name']).to eq updated_record['name']
  end

end

