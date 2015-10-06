namespace :imagemagick do
  desc "Install latest stable release of imagemagick"
  task :install, :roles => :app do
    run "#{sudo} apt-get -y update" unless mass_install?
    run "#{sudo} apt-get -y install imagemagick" if agree_on_mass_install "Install ImageMagick?" 
  end
  after "deploy:install", "imagemagick:install"
end