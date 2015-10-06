# raise "Please setup the enviornment in #{__FILE__}"

#Disable robot indexing
load "config/recipes/disable_robots"

#Server setup
#server "204.225.94.90", :web, :app, :db, :primary => true
server "192.168.10.2", :web, :app, :db, :primary => true

#DOMAIN (URL for site)
#STAGING URL must be exact
#set :domain, "mcblooms.anlek.com"
set :domain, "mcblooms.example.com"

#GIT
set :branch, "master"

#ENVIORNMENT
set :rails_env, 'staging'
