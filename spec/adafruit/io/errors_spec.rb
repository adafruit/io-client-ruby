require 'helper'

RSpec.describe Adafruit::IO::Error do
  it 'is the base class for all library errors' do
    expect(Adafruit::IO::RequestError.ancestors).to include(Adafruit::IO::Error)
    expect(Adafruit::IO::Arguments::ArgumentError.ancestors).to include(Adafruit::IO::Error)
  end

  it 'is raised for client argument errors' do
    client = Adafruit::IO::Client.new(key: MY_KEY)

    expect { client.feeds }.to raise_error(Adafruit::IO::Error, /username is nil/)
    expect { client.send_batch_data('f', 'nope', username: 'u') }.to raise_error(Adafruit::IO::Error, /array/)
  end

  it 'is raised for request errors' do
    client = Adafruit::IO::Client.new(key: MY_KEY, username: 'u')
    client.api_endpoint = TEST_URL
    stub_request(:get, /feeds/).to_return(status: 500, body: 'oops')

    expect { client.feeds }.to raise_error(Adafruit::IO::Error)
  end

  it 'is raised for mqtt errors' do
    raw_client = double('MQTT::Client', connected?: false)
    allow(::MQTT::Client).to receive(:connect).and_return(raw_client)
    mqtt = Adafruit::IO::MQTT.new('u', MY_KEY)

    expect { mqtt.publish('f', 1) }.to raise_error(Adafruit::IO::Error, /not connected/)
  end
end
