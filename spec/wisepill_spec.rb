require_relative "../lib/wisepill.rb"

RSpec.describe Wisepill do
  let(:wisepill) { Wisepill.new("user", "secret") }
  let(:xml_response) do
    <<-XML
      <WISEPILL>
        <RECORD>
          <GroupName>CBITS_NU</GroupName>
          <Device>1234</Device>
          <IDCode>foo-123</IDCode>
          <PatientName>Wisepill123</PatientName>
          <SignalStrength>7</SignalStrength>
          <BatteryVoltage>4020</BatteryVoltage>
          <USSDReply>N/A</USSDReply>
          <DeviceDateTime>2014-06-10 15:01:03</DeviceDateTime>
          <active>1</active>
        </RECORD>
        <RECORD>
          <GroupName>CBITS_NU</GroupName>
          <Device>2345</Device>
          <IDCode>foo-234</IDCode>
          <PatientName>Wisepill234</PatientName>
          <SignalStrength>8</SignalStrength>
          <BatteryVoltage>4080</BatteryVoltage>
          <USSDReply>N/A</USSDReply>
          <DeviceDateTime>2014-06-10 13:56:17</DeviceDateTime>
          <active>1</active>
        </RECORD>
      </WISEPILL>
    XML
  end

  describe "#time_opened" do
    it "returns 'unknown' when an exception is raised" do
      allow(wisepill).to receive(:open).and_raise("some problem")

      expect(wisepill.time_opened("id", "a date")).to eq "unknown"
    end

    it "returns 'unknown' when the id code is not found" do
      allow(wisepill).to receive(:open) { "" }

      expect(wisepill.time_opened("id", "a date")).to eq "unknown"
    end

    it "returns the timestamp when the id code is found" do
      allow(wisepill).to receive(:open) { double("io", read: xml_response, rewind: nil) }

      expect(wisepill.time_opened("foo-123", "a date")).to eq "2014-06-10 15:01:03 -0500"
    end
  end

  describe "#events" do
    it "returns an array of event properties" do
      allow(wisepill).to receive(:open) { double("io", read: xml_response, rewind: nil) }

      expect(wisepill.events("a date")).to eq [
        {
          group_name: "CBITS_NU",
          device: "1234",
          id_code: "foo-123",
          patient_name: "Wisepill123",
          signal_strength: 7,
          battery_voltage: 4020,
          ussd_reply: "N/A",
          device_date_time: Time.parse("2014-06-10 15:01:03 -0500"),
          active: 1
        },
        {
          group_name: "CBITS_NU",
          device: "2345",
          id_code: "foo-234",
          patient_name: "Wisepill234",
          signal_strength: 8,
          battery_voltage: 4080,
          ussd_reply: "N/A",
          device_date_time: Time.parse("2014-06-10 13:56:17 -0500"),
          active: 1
        }
      ]
    end
  end
end
