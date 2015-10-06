set_default(:nginx_application) { "#{application}_#{rails_env}" }
namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, :roles => :web do
    if agree_on_mass_install "Install Nginx?"
      #Uninstall Apache2 First
      run "#{sudo} apt-get -y remove --purge apache*"

      run "#{sudo} add-apt-repository ppa:nginx/stable"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nginx"
    end
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, :roles => :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{nginx_application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  desc "Setup a default site"
  task :default_site, :roles => [:web, :proxy] do
    template "nginx_default_site.erb", "/tmp/nginx_default_site"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    run "#{sudo} mv /tmp/nginx_default_site /etc/nginx/sites-enabled/_default"
    run "#{sudo} mkdir -p #{app_path}/_default/log"
    run "#{sudo} chown -R deployer:www-data #{app_path}/_default "
    template "nginx_default.html.erb", "#{app_path}/_default/404.html"
    restart
  end
  
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, :roles => :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
