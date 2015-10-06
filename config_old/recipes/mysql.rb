set_default(:using_mysql, true)
set_default(:mysql_server_ip) {
  server = roles[:db].servers.each do |server|
    break server if server.options[:no_release]
  end
  server || "127.0.0.1"
}
set_default(:mysql_requestor_ip) { 
  #TODO: Work with more than 1 server
  roles[:app].servers.first || "127.0.0.1"
}
set_default(:mysql_user) { "#{application.gsub(/[\.\-+]/,"_")[0,10]}_#{rand(36**5).to_s(36)}" } #name with random 5 char (mysql only allow 16 char usernames)
set_default(:mysql_password) { rand(36**15).to_s(36) }
set_default(:mysql_root_password) { Capistrano::CLI.password_prompt "Root password for MySql: " }
set_default(:mysql_database) { "#{application}_#{rails_env}".gsub(/[\.\-+]/,"_") }
set_default(:mysql_pid) { "/var/run/mysqld/mysqld.pid" }
namespace :mysql do
  desc "Install the latest stable release of MySQL."
  #Installs on app because sql gem can't build without it
  task :install, :roles => [:db, :app] do
    run "#{sudo} apt-get -y update" unless mass_install?
    run "#{sudo} apt-get -y install mysql-server mysql-client libmysqlclient-dev" do |channel, stream, data|
      # prompts for mysql root password (when blue screen appears)
      channel.send_data("#{mysql_root_password}\n\r") if data =~ /password/
    end if agree_on_mass_install "Install MySql?"
  end
  after "deploy:install", "mysql:install"

  desc "Create a database and user for this application."
  task :create_database, :roles => :db, :only => {:no_release => true} do
    run %Q{#{sudo} -u root mysql -p#{mysql_root_password} -e "CREATE USER '#{mysql_user}'@'#{mysql_requestor_ip}' IDENTIFIED BY '#{mysql_password}';"}
    run %Q{#{sudo} -u root mysql -p#{mysql_root_password} -e "CREATE DATABASE IF NOT EXISTS #{mysql_database};"}
    run %Q{#{sudo} -u root mysql -p#{mysql_root_password} -e "GRANT ALL PRIVILEGES ON #{mysql_database}.* to #{mysql_user}@#{mysql_requestor_ip};"}
    run %Q{#{sudo} -u root mysql -p#{mysql_root_password} -e "FLUSH PRIVILEGES;"}
  end
  after "deploy:setup", "mysql:create_database"

  desc "Generate the database.yml configuration file."
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template "mysql.yml.erb", "#{shared_path}/config/database.yml"
  end
  after "deploy:setup", "mysql:setup"

  desc "Symlink the database.yml file into latest release"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "mysql:symlink"

  desc "Shows the IP address of the mysql reqestor (app) server (for debugging)"
  task :requestor_ip do
    puts mysql_requestor_ip
  end

  desc "Shows the IP address for the mysql Server (for debugging)"
  task :server_ip do
    puts mysql_server_ip
  end
end
