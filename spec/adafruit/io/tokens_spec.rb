require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns tokens' do
    mock_response(
      path: api_path('tokens'),
      method: :get,
      status: 200,
      body: "[#{ fixture_json('token') }]",
    )

    tokens = @aio.tokens
    expect(tokens).not_to be_empty
  end

  it 'returns a single token' do
    mock_response(
      path: api_path('tokens', 1),
      method: :get,
      status: 200,
      body: fixture_json('token')
    )

    tokens = @aio.token(1)
    expect(tokens).not_to be_empty
  end

end

