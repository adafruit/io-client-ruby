require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns the list of activities' do
    mock_response(
      path: api_path('activities'),
      method: :get,
      status: 200,
      body: mock_activities_json,
    )

    activities = @aio.activities
    expect(activities).not_to be_empty
  end

  it 'deletes all activities' do
    mock_response(
      path: api_path('activities'),
      method: :delete,
      status: 200,
      body: ''
    )

    body = @aio.delete_activities
    expect(body).to be_empty
  end
end

