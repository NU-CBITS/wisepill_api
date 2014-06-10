require "json"
require_relative "lib/wisepill.rb"

app = proc do |env|
  username = ENV['wisepill_username']
  password = ENV['wisepill_password']
  wisepill = Wisepill.new(username, password)
  req = Rack::Request.new(env)
  id_code = req.params["id_code"]
  today = Date.today.strftime("%Y-%m-%d")

  [
    200,
    {
      "Content-Type" => "application/json",
      "Access-Control-Allow-Origin" => "*"
    },
    [
      {
        today: today,
        wasPillboxOpenedToday: wisepill.opened_pillbox?(id_code, today),
        pillboxLastOpened: wisepill.time_opened(id_code, today)
      }.to_json
    ]
  ]
end

run app
