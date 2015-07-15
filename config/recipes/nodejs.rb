namespace :nodejs do
  desc "Install the latest relase of Node.js"
  task :install, :roles => :app do
    if agree_on_mass_install "Install Node.JS (needed for Rails 3)?"
      run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nodejs"
    end
  end
  after "deploy:install", "nodejs:install"
end
