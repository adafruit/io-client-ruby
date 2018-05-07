require 'helper'

RSpec.describe Adafruit::IO::Client do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username'
    @aio.api_endpoint = TEST_URL
  end

  %w(feed group dashboard).each do |model_type|
    it "lists permissions for a #{model_type}" do
      mock_response(
        path: api_path("#{model_type}s", 'key', 'acl'),
        method: :get,
        status: 200,
        body: "[#{mock_permission_json}]",
      )

      response = @aio.permissions(model_type, 'key')
      expect(response).not_to be_empty
    end

    it "deletes a permission for a #{model_type}" do
      mock_response(
        path: api_path("#{model_type}s", 'key', 'acl', '1'),
        method: :delete,
        status: 200,
        body: mock_permission_json,
      )

      response = @aio.delete_permission(model_type, 'key', '1')
      expect(response).not_to be_empty
    end

    it "creates a public permision for a #{model_type}" do
      mock_response(
        path: api_path("#{model_type}s", 'key', 'acl'),
        method: :post,
        status: 200,
        with_request_body: true,
        body: mock_permission_json,
      )

      response = @aio.create_permission(model_type, 'key', {scope: 'public', mode: 'r'})
      expect(response).not_to be_empty
    end

    it "gets a permision for a #{model_type}" do
      mock_response(
        path: api_path("#{model_type}s", 'key', 'acl', '1'),
        method: :get,
        status: 200,
        body: mock_permission_json,
      )

      response = @aio.permission(model_type, 'key', '1')
      expect(response).not_to be_empty
    end

  end
end


