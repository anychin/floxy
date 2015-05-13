server '178.62.133.19', user: 'wwwfloxy_stage', roles: %w{app db web}
set :rails_env, "staging"
set :application, 'floxy_stage'
set :deploy_to, '/home/wwwfloxy_stage/floxy_stage'
nvm_path = "/home/wwwfloxy_stage/.nvm/versions/node/v0.12.2/bin"
set :default_env, { path: "#{nvm_path}:$PATH" }
set :bower_bin, '/home/wwwfloxy_stage/node_modules/bower/bin/bower'

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
