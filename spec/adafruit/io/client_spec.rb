require 'helper'

describe Adafruit::IO::Client do
  
  describe "configuration" do
    it "sets a valid key" do
      client = Adafruit::IO::Client.new :key => "random_key"
      expect(client.instance_variable_get(:"@key")).to eq "random_key"
    end
  end
end