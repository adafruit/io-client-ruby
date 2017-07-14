
TEST_URL = ENV['ADAFRUIT_IO_URL'] || 'http://io.adafruit.test'

shared_context "AdafruitIOv1" do
  before { @api_version = 'v1'}

  def mock_response(options={})
    request = stub_request(options[:method], URI::join(TEST_URL, "/#{ options[:path] }"))

    headers = {
      'Accept'=>'application/json',
      'Accept-Encoding'=>/.*/,
      'User-Agent'=> %r[AdafruitIO-Ruby/#{ Adafruit::IO::VERSION } \(.+\)],
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

  def mock_data_json
    fixture_json('data')
  end

  def mock_feed_record
    JSON.parse(mock_feed_json)
  end
end

shared_context "AdafruitIOv2" do
  before { @api_version = 'v2'}

  def mock_response(options={})
    request = stub_request(options[:method], URI::join(TEST_URL, "/#{ options[:path] }"))

    headers = {
      'Accept'=>'application/json',
      'Accept-Encoding'=>/.*/,
      'User-Agent'=> %r[AdafruitIO-Ruby/#{ Adafruit::IO::VERSION } \(.+\)],
      'X-Aio-Key'=>'blah'
    }

    if options[:with_request_body]
      headers['Content-Type'] = 'application/json'
      request.with(:body => /.*?/)
    end

    request.with(:headers => headers)

    # pagination
    if options[:method] =~ /get/i
      response_headers = {
        'X-Pagination-Count' => 1,
        'X-Pagination-Limit' => 1000,
        'X-Pagination-Start' => '2017-04-10T00:00:00Z',
        'X-Pagination-End' => '2017-04-12T00:00:00Z'
      }
    else
      response_headers = {}
    end

    request.to_return(:status => options[:status],
                      :body => options[:body],
                      :headers => response_headers)
  end

  %w(feed data feed_details token user group dashboard block).each do |k|
    define_method(:"mock_#{k}_json") do
      fixture_json(k)
    end

    define_method(:"mock_#{k}") do
      JSON.parse self.send(:"mock_#{k}_json")
    end
  end

  def api_path(*args)
    options = nil
    if args.last.is_a?(Hash)
      options = args.pop
    end

    username = @aio.username
    if options && options.has_key?(:username)
      username = options[:username]
    end

    File.join(*["api", "v2", username].concat(args.map(&:to_s)).compact)
  end
end
