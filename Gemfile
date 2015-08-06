source 'http://rubygems.org'

gem 'rails', '4.2.0'

# Bd
gem 'pg'
gem 'squeel'
# gem 'arel',      github: 'rails/arel'
# gem 'counter_culture', '~> 0.1.23'
# gem 'friendly_id', '~> 5.0.0'

# State machine
gem 'statesman'

# Authentication & Authorisation
gem 'devise', :git => 'https://github.com/plataformatec/devise.git', :branch => 'master'
gem 'authority'
gem 'rolify'
gem 'switch_user'
# gem "cancan"

# Validations
# gem 'validates'
# gem 'phony_rails', :git => 'git://github.com/joost/phony_rails.git'

# View Objects
gem 'model_pretender', :git => 'git://github.com/TinkerDev/model_pretender.git'

# Admin
# gem 'activeadmin', github: 'activeadmin'

# Config
gem 'settingslogic'

# Почта
# gem 'recipient_interceptor', :group => [:development, :test]

# Uploading
# gem 'mini_magick'
# gem 'rmagick'
# gem 'carrierwave'

# Views Core
gem 'slim-rails'
gem 'haml-rails'

# View Helpers
gem 'simple-navigation', '~> 3.12.2'
gem 'simple-navigation-bootstrap'
# gem 'authbuttons-rails'
gem 'active_link_to'
# gem 'breadcrumbs_on_rails'

# Presenters Decorators
gem 'draper'
gem 'cells'

# Forms
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git', branch: 'master'
gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'
gem 'momentjs-rails'
gem 'cocoon'

# Pagination
gem 'kaminari'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# JS runtime
gem 'therubyracer', platforms: :ruby

# Assets
# Js
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'role-rails'
gem 'uglifier', '~> 1.3'
gem 'coffee-rails'

# Css
gem 'sass-rails'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'compass'
gem 'compass-rails'
gem 'sprockets-rails'

# Queue
#gem 'redis-namespace'
#gem 'resque'
#gem 'resque-pool'
#gem 'resque-status'
# gem 'sidekiq'
# gem 'whenever', :require => false

# Errors
# gem 'airbrake_user_attributes'
gem 'airbrake', :github => 'airbrake/airbrake'

# Api
# gem 'grape', github: 'intridea/grape'
# gem 'grape-cors', github: 'cambridge-healthcare/grape-cors'
# gem 'grape-swagger-rails'
# gem 'grape-entity'
# gem 'jbuilder', '~> 2.0'

# Money
# gem 'money', :git=>'git://github.com/tinkerdev/money.git'
gem 'money-rails'
# gem 'russian_central_bank'

# Seo
# gem 'sitemap_generator', :git => 'git://github.com/kjvarga/sitemap_generator.git'
# gem 'meta-tags', :require=>'meta_tags'

# Truncation
# gem "html_truncator", "~>0.2"
# gem "hpricot", ">= 0.8.6"

# Performance
# gem 'gctools'

# Versions
gem 'semver2'

# Usefull Stuff
gem 'hashie'
# gem 'tinymce-rails'
# gem "jquery-fileupload-rails"
# gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
# gem 'jquery_datepicker'
# gem 'easy_captcha'
# gem 'x-editable-rails'
# gem 'select2-rails'
# gem 'rubylight', :git=>'git://github.com/azfire/rubylight.git'

gem 'puma'
gem 'pundit', :git=>'git://github.com/elabs/pundit.git'

# Soft delete
gem "paranoia", "~> 2.0"

group :development, :staging do
  gem "better_errors"
end


group :development do
  # gem 'ruby-graphviz'
  # gem 'holepicker', :require => false

  # Pry stuff
  gem 'pry-rails'
  gem 'pry-pretty-numeric' # 1_234_768
  gem 'pry-nav' # step, next, finish, continue, break
  gem 'pry-doc' # ? loop
  gem 'pry-docmore'

  gem "pry-stack_explorer" # show-stack in console

  gem 'awesome_print'

  # gem 'meta_request' # rails_panel in chrome

  gem 'quiet_assets'

  gem "mailcatcher", :require => false
  gem 'ruby-progressbar'

  # gem 'foreman'
  # deploy
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
  gem 'capistrano-rails-console'
  gem "capistrano-db-tasks", require: false
  gem 'capistrano-bower'
end


group :test do
  # Minimum pack
  gem "capybara"
  gem 'poltergeist'
  gem "database_cleaner"
  gem 'factory_girl_rails'

  # Seeds
  # gem 'forgery'
  # gem 'ffaker'

  # Specific Test Gems
  # gem "fakeredis", :require => "fakeredis/rspec"
  # gem 'resque_spec'
  # gem "email_spec", ">= 1.2.1"

  # Guard
  # gem 'guard', '>= 2.4.0'
  # gem 'guard-rspec'
  # gem 'guard-rails'
  # gem 'guard-spring'

  # Coverage
  # gem 'simplecov', :require => false
  # gem 'simplecov-rcov', :require => false

  # gem 'capybara-screenshot'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'railroady'
  gem "rails-erd"
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

# group :deploy do
#   gem 'capistrano', '~> 3.2', :require => false
#   gem 'capistrano-rbenv', :require => false
#   gem 'capistrano-rails', '~> 1.1', :require => false
#   gem 'capistrano-bundler', :github => 'capistrano/bundler', :require => false
#   gem "capistrano-db-tasks", require: false
#   gem 'sidekiq', :require => false
# end

group :production do
  gem 'newrelic_rpm'
end
