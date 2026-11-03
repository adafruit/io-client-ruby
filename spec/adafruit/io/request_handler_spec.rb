require 'helper'

RSpec.describe Adafruit::IO::RequestHandler do
  include_context "AdafruitIOv2"

  before do
    @aio = Adafruit::IO::Client.new key: MY_KEY, username: 'test_username', debug: true
    @aio.api_endpoint = TEST_URL
  end

  def stub_feed(body:, content_type: nil)
    headers = content_type ? { 'Content-Type' => content_type } : {}
    stub_request(:get, URI.join(TEST_URL, "/#{api_path('feeds', 'f')}"))
      .to_return(status: 200, body: body, headers: headers)
  end

  it 'returns JSON responses parsed without parse errors in debug mode' do
    stub_feed(body: '{"key":"f"}', content_type: 'application/json')

    result = nil
    expect { result = @aio.feed('f') }.not_to output(/ERROR PARSING JSON/).to_stdout
    expect(result).to eq('key' => 'f')
  end

  it 'parses JSON bodies without a JSON content type' do
    stub_feed(body: '{"key":"f"}')

    expect(@aio.feed('f')).to eq('key' => 'f')
  end

  it 'returns non-JSON bodies as strings' do
    stub_feed(body: 'not json', content_type: 'text/plain')

    expect(@aio.feed('f')).to eq 'not json'
  end
end
