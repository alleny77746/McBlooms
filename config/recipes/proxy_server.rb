def proxy_server?
  roles[:proxy].servers.count > 0
end

def proxy_server_id
  roles[:proxy].servers.first
end

if proxy_server?
  namespace :nginx do
    namespace :proxy do
      desc "Install nginx on proxy server"
      task :install_server, :roles => :proxy do
        run "#{sudo} add-apt-repository ppa:nginx/stable"
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install nginx"
        run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
      end

      desc "Setup nginx configuration on proxy server for this application"
      task :setup, :roles => :proxy do
        template "nginx_proxy_unicorn.erb", "/tmp/nginx_proxy_conf"
        run "#{sudo} mkdir -p /var/log/nginx/log"
        run "#{sudo} mv /tmp/nginx_proxy_conf /etc/nginx/sites-enabled/#{nginx_application}"
        restart
      end
      before "nginx:setup", "nginx:proxy:setup"
      
      %w[start stop restart].each do |command|
        desc "#{command} proxy nginx"
        task command, :roles => :proxy do
          run "#{sudo} service nginx #{command}"
        end
     end
      
    end
  end
end