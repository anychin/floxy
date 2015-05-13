# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components', 'font-awesome', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w(.svg .eot .woff .ttf)
# Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/

# Rails.application.config.assets.precompile += ['font-awesome/fonts/fontawesome-webfont.eot']
Rails.application.config.assets.precompile << %r(font-awesome/fonts/[\w-]+\.(?:eot|svg|ttf|woff|woff2?)$)

# Rails.application.config.assets.precompile << %r(font-awesome/fonts/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
# Minimum Sass number precision required by bootstrap-sass
# ::Sass::Script::Value::Number.precision = [8, ::Sass::Script::Value::Number.precision].max


