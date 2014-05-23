require_relative "../lib/wisepill.rb"

RSpec.describe Wisepill do
  describe "#time_opened" do
    let(:wisepill) { Wisepill.new("user", "secret") }

    it "returns 'unknown' when an exception is raised" do
      allow(wisepill).to receive(:open).and_raise("some problem")
      expect(wisepill.time_opened("id", "a date")).to eq "unknown"
    end

    it "returns 'unknown' when the id code is not found" do
      allow(wisepill).to receive(:open) { "" }
      expect(wisepill.time_opened("id", "a date")).to eq "unknown"
    end

    it "returns the timestamp when the id code is found" do
      allow(wisepill).to receive(:open)
        .and_return("<WISEPILL><RECORD><IDCode>id</IDCode><DeviceDateTime>2014-05-18 08:22:32</DeviceDateTime></RECORD></WISEPILL>")
      expect(wisepill.time_opened("id", "a date")).to eq "2014-05-18 08:22:32 -0500"
    end
  end
end
