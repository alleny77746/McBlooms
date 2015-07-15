namespace :mongodb do
  desc "Install the latest relase of MongoDB"
  task :install, :roles => :db do
    if agree_on_mass_install "Install MongoDB?"
      run "#{sudo} apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
      run "#{sudo} sh -c \"echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list\""
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install mongodb-10gen"
    end
  end
  after "deploy:install", "mongodb:install"

  desc "System Link Config File (if exists)"
  task :link, :roles => :app do
    mongoid_yml_file = "config/mongoid.yml"
    path = File.join(shared_path, mongoid_yml_file)
    if remote_file_exists?(path)
      run "ln -nfs #{shared_path}/#{mongoid_yml_file} #{current_path}/#{mongoid_yml_file}"
    else
      logger.trace "#{path} not found, so it wasn't link" if logger
    end
  end
  after 'deploy:create_symlink', 'mongodb:link'
end
