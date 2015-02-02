set :stage, :staging
set :application, 'stage.HOSTNAME'
server 'SERVERNAME', user: 'USERNAME', roles: %w{web app db}
set :rails_env, :staging
set :branch, proc { ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp }
fetch(:default_env).merge!(rails_env: :staging)
