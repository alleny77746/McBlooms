require 'sidekiq/capistrano'

set_default(:using_sidekiq, true)

set_default(:sidekiq_pid)       { "#{shared_path}/pids/sidekiq.pid" }
set_default(:sidekiq_config)    { "#{current_path}/config/sidekiq.yml" }
set_default(:sidekiq_cmd)       { "#{fetch(:bundle_cmd, "bundle")} exec sidekiq" }
set_default(:sidekiqctl_cmd)    { "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl" }
set_default(:sidekiq_timeout)   { 10 }
set_default(:sidekiq_role)      { :app }
set_default(:sidekiq_pid)       { "#{current_path}/tmp/pids/sidekiq.pid" }
set_default(:sidekiq_processes) { 1 }

namespace :sidekiq do
  desc "Install Redis"
  task :install do
    run "#{sudo} apt-get -y install redis-server" if agree_on_mass_install("Install Redis Server for Sidekiq?")
  end
  after "deploy:install", "sidekiq:install"
end
