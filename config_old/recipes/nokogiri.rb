namespace :nokogiri do
  desc "Install pre-requirements for nokogiri"
  task :install, :roles => :app do
    if agree_on_mass_install "Install nokogiri requirements?"
      run "#{sudo} apt-get -y update" unless mass_install?
      run "#{sudo} apt-get -y install libxslt-dev libxml2-dev"
    end
  end
  after "deploy:install", "nodejs:nokogiri"
end
