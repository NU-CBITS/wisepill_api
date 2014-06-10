require "nokogiri"
require "open-uri"

class Wisepill
  attr_reader :url, :raw_xml

  def initialize(username, password)
    @username = username
    @password = password
  end

  def opened_pillbox?(id_code, date_str)
    time_opened(id_code, date_str) != "unknown"
  end

  def time_opened(id_code, date_str)
    xpath = "//wisepill//record[//idcode[text()='#{ id_code }']]//devicedatetime"
    datetime = doc(date_str).at_xpath(xpath)

    datetime.nil? ? "unknown" : Time.parse(datetime.text).to_s
  end

  def events(date_str)
    doc(date_str).xpath("//wisepill//record").map do |record|
      {
        group_name: record.xpath("groupname").first.content,
        device: record.xpath("device").first.content,
        id_code: record.xpath("idcode").first.content,
        patient_name: record.xpath("patientname").first.content,
        signal_strength: record.xpath("signalstrength").first.content.to_i,
        battery_voltage: record.xpath("batteryvoltage").first.content.to_i,
        ussd_reply: record.xpath("ussdreply").first.content,
        device_date_time: Time.parse(record.xpath("devicedatetime").first.content).to_time,
        active: record.xpath("active").first.content.to_i
      }
    end
  end

  private

  def doc(date_str)
    @docs ||= {}
    @url = ["http://mediscern.com/USA_UI/api/wpapi.php?username=#{ @username }",
           "password=#{ @password }",
           "startdate=#{ date_str }",
           "enddate=#{ date_str }",
           "dataformat=xml",
           "compressdata=false"].join("&")

    @docs[date_str] ||= (
      io = open(@url)
      @raw_xml = io.read
      io.rewind
      Nokogiri::HTML(io)
    )

  rescue
    Nokogiri::HTML ""
  end
end
