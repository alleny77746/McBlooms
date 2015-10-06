set_default(:ruby_version) { ask("What is the base ruby version you want to install?") { |q| q.default="1.9.3-p392" } }
set_default(:rbenv_root) {"/usr/local/rbenv"}
set_default(:rbenv_setup_command) {"source /etc/profile.d/rbenv.sh"}
set :default_environment, {
  'PATH' => "#{rbenv_root}/shims:#{rbenv_root}/bin:$PATH"
}

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, :roles => [:app, :web] do
    if agree_on_mass_install "Install rbenv? (very recommended)"
      run "#{sudo} apt-get -y update" unless mass_install?
      run "#{sudo} apt-get -y install curl git-core zlib1g-dev libssl-dev"

      rbenv.upgrade
      
      run "#{sudo} ln -s #{rbenv_root} $HOME/.rbenv"

      bashrc = <<-BASHRC
if [ -d $HOME/.rbenv ]; then 
  export PATH="$HOME/.rbenv/bin:$PATH" 
  eval "$(rbenv init -)" 
fi
BASHRC
      put bashrc, "/tmp/rbenvrc"
      run "cat /tmp/rbenvrc $HOME/.bashrc > $HOME/.bashrc.tmp"
      run "mv $HOME/.bashrc.tmp $HOME/.bashrc"

      
      run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
      run %q{eval "$(rbenv init -)"}
      
      choose do |menu|
        menu.prompt = "Which version of the OS are you running on this server?"
        menu.choice("Ubuntu 12.04 LTS") {
          run "#{sudo} apt-get -y install libreadline-gplv2-dev"
        }
        menu.choices("Ubuntu 10.04 LTS", "Debian"){
          run "#{sudo} apt-get -y install libreadline5-dev"
        }
      end

      run "rbenv install #{ruby_version} && rbenv global #{ruby_version}"
      run "gem install bundler --no-ri --no-rdoc && rbenv rehash"
    end
  end
  after "deploy:install", "rbenv:install"

  desc "Upgrade rbenv"
  task :upgrade, :roles => [:app, :web] do
    template "rbenv_installer.sh.erb", "/tmp/rbenv_installer.sh"
    run "#{sudo} chmod +x /tmp/rbenv_installer.sh"
    run "#{sudo} /tmp/rbenv_installer.sh" 
    run "#{sudo} rm /tmp/rbenv_installer.sh"
  end
end
