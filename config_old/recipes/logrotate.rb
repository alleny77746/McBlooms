set_default(:logrotate_name) { "#{application}_#{rails_env}" }
namespace :logrotate do
	desc "Sets up a log rotation"
  task :setup, :roles => :web do
    template "logrotate.erb", "/tmp/logrotate_conf"
    run "#{sudo} mv /tmp/logrotate_conf /etc/logrotate.d/#{logrotate_name}"
  end
  after "deploy:setup", "logrotate:setup"
end
