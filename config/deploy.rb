load "config/recipes/base"

load "config/recipes/bundler"


# set :environments, [:Staging, :Production, :Testing]
load "config/recipes/setup_environment"

##### GLOBAL SETTINGS ######
#APPLICATION
set :application, "mcblooms" #This is the name from the gitlab under "Git Clone" 

#GIT
set :git_repo, "basket-company/mcblooms" #If application can't be the repo nname, change it here

#############################



### NOTE: DO NOT CHANGE ANYTHING BELOW ###

#set :user, 'deployer'
set :user, 'greg'

set :scm, :git
# set :repository,  "git@gitlab.anlek.com:#{git_repo}.git"
set :repository, "git@github.com:alleny77746/McBlooms.git"


set :deploy_to, "#{app_path}/#{application}/#{rails_env}"
set :deploy_via, :remote_cache

set :bundle_without, [:development, :test, :mswin]

set :use_sudo, false

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true



after "deploy", "deploy:cleanup" # keep only the last 5 releases



### LOAD REQURIEMENTS FOR THIS APP

load "config/recipes/proxy_server"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/imagemagick"
#load "config/recipes/postgresql"
load "config/recipes/mysql"
load "config/recipes/mongodb"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/rake"
load "config/recipes/rails"
# load "config/recipes/depricated"
# load "config/recipes/sidekiq"
# load "config/recipes/delayed_job"
# load "config/recipes/dragonfly"
load "config/recipes/monit"
# load "config/recipes/whenever"
load "config/recipes/logrotate"
