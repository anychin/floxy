set :stage, :production
server 'SERVERNAME', user: 'USERNAME', port: 22, roles: %w{web app db}
set :rails_env, :production
set :branch, ENV['BRANCH'] || 'master'
fetch(:default_env).merge!(rails_env: :production)
