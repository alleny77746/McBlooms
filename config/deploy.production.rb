raise "Please setup the enviornment in #{__FILE__}"

#Server setup
server "204.225.94.90", :web, :app, :db, :primary => true

#DOMAIN (URL for site)
#NOTE: if you specify www in the domain, it will redirect non-www and vise versa
set :domain, "mcblooms.com"

# Setup SSL?
# set :using_ssl, true

#GIT
set :branch, 'production'

#ENVIORNMENT
set :rails_env, 'production'

#MONIT SETTINGS
set :monit_smtp_server, "smtp.gmail.com"
set :monit_smtp_port, "587"
set :monit_smtp_username, "do_not_reply@anlek.com"
set :monit_smtp_password, "ak212606"
set :monit_from_address, "do_not_reply@anlek.com"
set :monit_to_address, "server-errors@anlek.com"
set :monit_admin_port, "2418"
set :monit_admin_password, "212606"
set :monit_server_name, "McBlooms Server"
