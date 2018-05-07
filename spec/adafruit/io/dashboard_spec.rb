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

  it 'creates a dashboard' do
    mock_response(
      path: api_path('dashboards'),
      method: :post,
      status: 200,
      body: mock_create_dashboard_json,
    )

    dashboard = @aio.create_dashboard(JSON.parse(mock_create_dashboard_json))
    expect(dashboard).not_to be_empty
  end

  it 'updates a dashboard' do
    mock_response(
      path: api_path('dashboards', 'dashboard-key'),
      method: :put,
      status: 200,
      body: mock_dashboard_json,
    )

    dashboard = @aio.update_dashboard(key: 'dashboard-key', name: 'New Name')
    expect(dashboard).not_to be_empty
  end

  it 'updates dashboard layouts' do
    mock_response(
      path: api_path('dashboards', 'dashboard-key', 'update_layouts'),
      method: :post,
      status: 200,
      body: mock_dashboard_json,
    )

    dashboard = @aio.update_dashboard_layouts(key: 'dashboard-key', layouts: JSON.parse(mock_layouts_json))
    expect(dashboard).not_to be_empty
  end

  it 'deletes a dashboard' do
    mock_response(
      path: api_path('dashboards', 'dashboard-key'),
      method: :delete,
      status: 200,
      body: mock_dashboard_json,
    )

    dashboard = @aio.delete_dashboard(key: 'dashboard-key')
    expect(dashboard).not_to be_empty
  end

end

