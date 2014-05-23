# Wisepill API

## Running locally

`wisepill_username=my_username wisepill_password=my_password rackup config.ru`

`open http://localhost:9292/?id_code=MY-WISEPILL-ID`

`{"today":"2014-05-22","wasPillboxOpenedToday":false,"pillboxLastOpened":"unknown"}`

## Running specs

`gem install rspec`

`rspec spec/wisepill.rb`
