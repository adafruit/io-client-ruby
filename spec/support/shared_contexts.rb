
shared_context "AdafruitIOv1" do
  before { @api_version = 'v1'}

  def mock_response(options={})
    request = stub_request(options[:method], "https://io.adafruit.com/#{ options[:path] }")

    headers = {
      'Accept'=>'application/json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>"AdafruitIO-Ruby/#{ Adafruit::IO::VERSION }",
      'X-Aio-Key'=>'blah'
    }

    if options[:with_request_body]
      headers['Content-Type'] = 'application/json'
      request.with(:body => /.*?/)
    end

    request.with(:headers => headers)

    request.to_return(:status => options[:status],
                      :body => options[:body],
                      :headers => {})
  end

  def mock_feed_json
    fixture_json('feed')
  end

  def mock_feed_record
    JSON.parse(mock_feed_json)
  end
end
