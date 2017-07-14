require 'helper'

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

    puts JSON.pretty_generate(blocks)
  end

  it 'returns a block' do
    mock_response(
      path: api_path('dashboards', 'db', 'blocks', 1),
      method: :get,
      status: 200,
      body: mock_block_json,
    )

    block = @aio.block(dashboard_key: 'db', id: 1)
    expect(block).not_to be_empty

    puts JSON.pretty_generate(block)
  end

end

