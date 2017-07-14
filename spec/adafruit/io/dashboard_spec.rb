require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  it 'returns dashboards' do
    mock_response(
      path: api_path('dashboards'),
      method: :get,
      status: 200,
      body: "[#{mock_dashboard_json}]",
    )

    dashboards = @aio.dashboards
    expect(dashboards).not_to be_empty
  end

  it 'returns a dashboard' do
    mock_response(
      path: api_path('dashboards', 'dashboard-key'),
      method: :get,
      status: 200,
      body: mock_dashboard_json,
    )

    dashboards = @aio.dashboard('dashboard-key')
    expect(dashboards).not_to be_empty
  end

  it 'creates a dashboard'
  it 'adds a block to a dashboard'
  it 'updates a dashboard'
  it 'deletes a dashboard'

end

