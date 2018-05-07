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

  it 'creates a group' do
    mock_response(
      path: api_path('groups'),
      method: :post,
      status: 200,
      with_request_body: true,
      body: mock_group_json,
    )

    group = @aio.create_group(key: 'group-key', name: 'Group Name', description: "group description")
    expect(group).not_to be_empty
  end

  it 'updates a group' do
    mock_response(
      path: api_path('groups', 'group-key'),
      method: :put,
      status: 200,
      body: mock_group_json,
    )

    group = @aio.update_group(key: 'group-key', name: 'Group Other Name')
    expect(group).not_to be_empty
  end

  it 'deletes a group' do
    mock_response(
      path: api_path('groups', 'group-key'),
      method: :delete,
      status: 200,
      body: mock_group_json
    )

    result = @aio.delete_group(key: 'group-key')
    expect(result).to_not be_empty
  end

  it 'adds a feed to a group' do
    mock_response(
      path: api_path('groups', 'group-key', 'add'),
      method: :post,
      status: 200,
      with_request_body: true,
      body: mock_group_json,
    )

    result = @aio.group_add_feed('group-key', 'other.feed-key')
    expect(result).to_not be_empty
  end

  it 'removes a feed from a group' do
    mock_response(
      path: api_path('groups', 'group-key', 'remove'),
      method: :post,
      status: 200,
      with_request_body: true,
      body: mock_group_json,
    )

    result = @aio.group_remove_feed('group-key', 'feed-key')
    expect(result).to_not be_empty
  end

  it 'raises on failure to remove a feed from a group' do
    mock_response(
      path: api_path('groups', 'non-available-key', 'remove'),
      method: :post,
      status: 404,
      with_request_body: true,
      body: '{"error":"not found - API documentation can be found at https://io.adafruit.com/api/docs"}',
    )

    expect {
      @aio.group_remove_feed('non-available-key', 'feed-key')
    }.to raise_error(Adafruit::IO::RequestError)
  end

end
