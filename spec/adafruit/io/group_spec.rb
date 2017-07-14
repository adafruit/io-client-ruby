require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns groups' do
    mock_response(
      path: api_path('groups'),
      method: :get,
      status: 200,
      body: "[#{mock_group_json}]",
    )

    groups = @aio.groups
    expect(groups).not_to be_empty
  end

  it 'returns a group' do
    mock_response(
      path: api_path('groups', 'group-key'),
      method: :get,
      status: 200,
      body: mock_group_json,
    )

    groups = @aio.group('group-key')
    expect(groups).not_to be_empty
  end

  it 'creates a group'
  it 'adds a feed to a group'
  it 'updates a group'
  it 'deletes a group'

end
