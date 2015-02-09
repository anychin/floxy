require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/puma'

set :rails_env, 'production'
set :domain, '188.226.198.167'
set :port, 523
set :user, 'deploy'
set :term_mode, nil

set :deploy_to, "/home/#{user}/floxy/#{rails_env}"
set :app_path, "#{deploy_to}/#{current_path}"
set :repository, 'git@bitbucket.org:webiumdigital/floxy_prototype.git'
set :branch, ENV['BRANCH'] || 'master'
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'tmp']
set :keep_releases, 10
set :rvm_path, "/home/#{user}/.rvm/scripts/rvm"

task :environment do
  invoke 'rvm:use[ruby-2.2.0@default]'
end

#delay. Setup task
# ==============================================================================
task :setup do
  queue! %{
mkdir -p "#{deploy_to}/shared/tmp/pids"
}
  queue! %{
mkdir -p "#{deploy_to}/shared/tmp/sockets"
}
  queue! %{
mkdir -p "#{deploy_to}/shared/config"
}
end

# Deploy task
# ==============================================================================
desc "deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke 'git:clone'
    invoke 'bundle:install'
    invoke 'deploy:link_shared_paths'
    invoke 'rails:db_migrate'
    invoke 'rails:assets_precompile'

    to :launch do
      invoke :'puma:restart'
    end
  end
end
