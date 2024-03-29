require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Floxy
  mattr_accessor :version

  # Depreate I18n warngings
  I18n.enforce_available_locales = true

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    #
    # TODO :ru is not valid locale

    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = [:en, :ru]
    config.i18n.default_locale = :ru
    config.i18n.fallbacks = true

    # config.paths.add "app/api", glob: "**/*.rb"
    # config.paths.add "app/navigation_renderers", glob: "**/*.rb"
    # config.paths.add "app/policies/organization_policies", glob: "**/*.rb"
    # config.autoload_paths += Dir[
    #   "#{Rails.root}/app/api/*",
    #   "#{Rails.root}/app/navigation_renderers/*",
    #   "#{Rails.root}/app/policies/organization_policies/*",
    # ]
  end
end
