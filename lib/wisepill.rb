require "nokogiri"
require "open-uri"

class Wisepill
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

  private

  def doc(date_str)
    @docs ||= {}
    url = ["http://mediscern.com/USA_UI/api/wpapi.php?username=#{ @username }",
           "password=#{ @password }",
           "startdate=#{ date_str }",
           "enddate=#{ date_str }",
           "dataformat=xml",
           "compressdata=false"].join("&")

    @docs[date_str] ||= Nokogiri::HTML(open(url))

  rescue
    Nokogiri::HTML ""
  end
end
