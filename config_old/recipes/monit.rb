set_default(:monit_smtp_server, "smtp.gmail.com")
set_default(:monit_smtp_port, "587")
set_default(:monit_smtp_username, "do_not_reply@parador.com")
set_default(:monit_smtp_password, "DNR2008")
set_default(:monit_from_address, "Do_Not_Reply@parador.com")
set_default(:monit_to_address, "server-errors@parador.com")
set_default(:monit_admin_port, "2418")
set_default(:monit_admin_password, "2418Salsa")
set_default(:monit_server_name, "the_server")

namespace :monit do
  desc "Install Monit"
  task :install do
    run "#{sudo} apt-get -y update" unless mass_install?
    run "#{sudo} apt-get -y install monit" if agree_on_mass_install "Install Monit?"
  end
  after "deploy:install", "monit:install"

  desc "Setup all Monit configuration"
  task :setup do
    monit_config "monitrc", "/etc/monit/monitrc"
    nginx
    postgresql if exists? :using_postgresql
    mysql if exists? :using_mysql
    sidekiq if exists? :using_sidekiq
    unicorn
    ssh
    cron
    syntax
    restart
  end
  if production?
    after "deploy:cold", "monit:setup"
  end

  task(:nginx, :roles => [:web, :proxy]) { monit_config "nginx" }
  task(:postgresql, :roles => :db) { monit_config "postgresql" }
  task(:mysql, :roles => :db) {monit_config "mysql"}
  task(:sidekiq, :roles => :app) { monit_config "sidekiq", "/etc/monit/conf.d/sidekiq_#{application}_#{rails_env}.conf"}
  task(:unicorn, :roles => :app) { monit_config "unicorn", "/etc/monit/conf.d/unicorn_#{application}_#{rails_env}.conf" }
  task(:ssh) { monit_config "ssh" }
  task(:cron) { monit_config "cron" }

  %w[start stop restart syntax force-reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      run "#{sudo} service monit #{command}"
    end
  end
end

def monit_config(name, destination = nil)
  destination ||= "/etc/monit/conf.d/#{name}.conf"
  template "monit/#{name}.erb", "/tmp/monit_#{name}"
  run "#{sudo} mv /tmp/monit_#{name} #{destination}"
  run "#{sudo} chown root #{destination}"
  run "#{sudo} chmod 600 #{destination}"
end
