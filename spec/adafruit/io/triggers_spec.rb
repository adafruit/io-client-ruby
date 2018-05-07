require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'gets the list of triggers' do
    mock_response(
      path: api_path('triggers'),
      method: :get,
      status: 200,
      body: "[#{mock_trigger_json}]",
    )

    response = @aio.triggers
    expect(response).not_to be_empty
  end

  it 'creates a trigger' do
    mock_response(
      path: api_path('triggers'),
      method: :post,
      status: 200,
      with_request_body: true,
      body: mock_trigger_json,
    )

    response = @aio.create_trigger(JSON.parse(mock_create_trigger_json))
    expect(response).not_to be_empty
  end

  it 'gets a trigger' do
    mock_response(
      path: api_path('triggers', '1'),
      method: :get,
      status: 200,
      body: mock_trigger_json,
    )

    response = @aio.trigger(1)
    expect(response).not_to be_empty
  end

  it 'updates a trigger' do
    mock_response(
      path: api_path('triggers', '1'),
      method: :put,
      status: 200,
      body: mock_trigger_json,
    )

    response = @aio.update_trigger(1, {value: 100})
    expect(response).not_to be_empty
  end

  it 'deletes a trigger' do
    mock_response(
      path: api_path('triggers', '1'),
      method: :delete,
      status: 200,
      body: mock_trigger_json,
    )

    response = @aio.delete_trigger(1)
    expect(response).not_to be_empty
  end
end


