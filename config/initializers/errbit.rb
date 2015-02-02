if defined? Airbrake
  Airbrake.configure do |config|
    config.api_key = 'API_KEY'
    config.host    = 'errbit.brandymint.ru'
    config.port    = 80
    config.secure  = config.port == 443
    config.user_attributes = [:id, :to_s]
  end
end
