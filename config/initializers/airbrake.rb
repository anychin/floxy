Airbrake.configure do |config|
  config.api_key = '3e1f94cecadb49ceeb0fd8216160b8b0'
  config.host    = 'errbit.tinkerdev.ru'
  config.port    = 80
  config.secure  = config.port == 443
end
