if defined? GrapeSwaggerRails
  GrapeSwaggerRails.options.url      = '/api/swagger_doc.json'
  GrapeSwaggerRails.options.app_name = 'Swagger'
  GrapeSwaggerRails.options.app_url  = '/api/swagger'

  #if Rails.env.development?
    #GrapeSwaggerRails.headers = { 'X-FairPrice-Key' => 'f71809f7311fc105bc1657c63e2c78e3ff6005c36b8d317a' }  #ipelican app key
  #end
end

# GrapeSwaggerRails.options.headers['Special-Header'] = 'Some Secret Value']
# GrapeSwaggerRails.options.api_auth     = 'basic'
# GrapeSwaggerRails.options.api_key_name = 'Authorization'
# GrapeSwaggerRails.options.api_key_type = 'header''

#GrapeSwaggerRails.options.authenticate_with do |request|
  ## 1. Inspect the `request` or access the Swagger UI controller via `self`
  ## 2. Check `current_user` or `can? :access, :api`, etc....
  ## 3. return a boolean value
#end`
