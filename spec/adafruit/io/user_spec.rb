require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns user' do
    mock_response(
      path: api_path('user', username: nil),
      method: :get,
      status: 200,
      body: "[#{mock_user_json}]",
    )

    user = @aio.user
    expect(user).not_to be_empty
  end

end

