require 'helper'

RSpec.describe Adafruit::IO::MQTT do
  let(:raw_client) { double('MQTT::Client', connected?: true) }

  before do
    allow(::MQTT::Client).to receive(:connect).and_return(raw_client)
  end

  subject(:mqtt) { Adafruit::IO::MQTT.new('test_username', MY_KEY) }

  describe '#publish' do
    it 'publishes a plain value' do
      expect(raw_client).to receive(:publish) do |topic, payload|
        expect(topic).to eq 'test_username/f/feed-key'
        expect(JSON.parse(payload)).to eq('value' => '42')
      end

      mqtt.publish('feed-key', 42)
    end

    it 'publishes a value with location' do
      expect(raw_client).to receive(:publish) do |topic, payload|
        expect(topic).to eq 'test_username/f/feed-key'
        expect(JSON.parse(payload)).to eq(
          'value' => '42', 'lat' => 40.7, 'lon' => -74.0, 'ele' => 10
        )
      end

      mqtt.publish('feed-key', 42, lat: 40.7, lon: -74.0, ele: 10)
    end
  end

  describe '#publish_group' do
    it 'publishes group values with location' do
      expect(raw_client).to receive(:publish) do |topic, payload|
        expect(topic).to eq 'test_username/g/group-key'
        expect(JSON.parse(payload)).to eq(
          'feeds' => { 'temp' => 72 },
          'location' => { 'lat' => 40.7, 'lon' => -74.0, 'ele' => nil }
        )
      end

      mqtt.publish_group('group-key', { 'temp' => 72 }, lat: 40.7, lon: -74.0)
    end
  end
end
