require 'helper'

RSpec.describe Adafruit::IO::Arguments do
  let(:args) { Class.new { include Adafruit::IO::Arguments }.new }

  describe '#get_key_from_arguments' do
    it 'accepts a string' do
      expect(args.get_key_from_arguments(['feed-key'])).to eq 'feed-key'
    end

    it 'accepts a hash with a symbol or string key' do
      expect(args.get_key_from_arguments([{ key: 'a' }])).to eq 'a'
      expect(args.get_key_from_arguments([{ 'key' => 'b' }])).to eq 'b'
    end

    it 'accepts an object that responds to key' do
      record = Struct.new(:key).new('c')
      expect(args.get_key_from_arguments([record])).to eq 'c'
    end

    it 'raises a clear error for a hash without a key' do
      expect {
        args.get_key_from_arguments([{ name: 'no key here' }])
      }.to raise_error(RuntimeError, /unrecognized object or key value/)
    end
  end

  describe '#get_id_from_arguments' do
    it 'raises a clear error for a hash without an id' do
      expect {
        args.get_id_from_arguments([{ name: 'no id here' }])
      }.to raise_error(RuntimeError, /unrecognized object or id value/)
    end
  end
end
