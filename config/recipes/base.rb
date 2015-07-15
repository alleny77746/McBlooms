def production?
  return false unless exists? :environment
  environment == :production
end

def using_ssl?
  return false unless exists? :using_ssl
  !!using_ssl
end

def error msg, status = 1
  at_exit { puts "#{msg}" }
  exit status
end

def ask(question, &block)
  Capistrano::CLI.ui.ask(question, answer_type = String ) {|q| yield q }
end

def choose(*items, &block)
  Capistrano::CLI.ui.choose(*items){ |menu| yield menu }
end

def agree msg, default="yes"
  Capistrano::CLI.ui.agree(msg) do |q| 
    q.default = default
  end
end

def agree_on_mass_install msg, default="yes", return_value=true
  return return_value unless mass_install?
  agree msg, default
end

def mass_install?
  exists?(:mass_install) && mass_install
end

def template(from, to)  
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def remote_file_exists?(path)
  results = []
  invoke_command("if [ -e '#{path}' ]; then echo -n 'true'; fi") do |ch, stream, out|
    results << (out == 'true')
  end  
  !results.empty? && results.all?
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

set_default(:app_path, "/var/www")

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    set :mass_install, true
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get install -y build-essential g++"
    deploy.install_apt_repo
  end

  task :setup, :roles => :web, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')}"
    run "#{try_sudo} chmod g+w #{dirs.join(' ')}" if fetch(:group_writable, true)
  end

   desc <<-DESC
    Test deployment dependencies. Checks things like directory permissions, \
    necessary utilities, and so forth, reporting on the things that appear to \
    be incorrect or missing. This is good for making sure a deploy has a \
    chance of working before you actually run `cap deploy'.

    You can define your own dependencies, as well, using the `depend' method:

      depend :remote, :gem, "tzinfo", ">=0.3.3"
      depend :local, :command, "svn"
      depend :remote, :directory, "/u/depot/files"
  DESC
  task :check, :roles => :web, :except => { :no_release => true } do
    dependencies = strategy.check!

    other = fetch(:dependencies, {})
    other.each do |location, types|
      types.each do |type, calls|
        if type == :gem
          dependencies.send(location).command(fetch(:gem_command, "gem")).or("`gem' command could not be found. Try setting :gem_command")
        end

        calls.each do |args|
          dependencies.send(location).send(type, *args)
        end
      end
    end

    if dependencies.pass?
      puts "You appear to have all necessary dependencies installed"
    else
      puts "The following dependencies failed. Please check them and try again:"
      dependencies.reject { |d| d.pass? }.each do |d|
        puts "--> #{d.message}"
      end
      abort
    end
  end

  desc <<-DESC
    Copies your project to the remote servers. This is the first stage \
    of any deployment; moving your updated code and assets to the deployment \
    servers. You will rarely call this task directly, however; instead, you \
    should call the `deploy' task (to do a complete deploy) or the `update' \
    task (if you want to perform the `restart' task separately).

    You will need to make sure you set the :scm variable to the source \
    control software you are using (it defaults to :subversion), and the \
    :deploy_via variable to the strategy you want to use to deploy (it \
    defaults to :checkout).
  DESC
  task :update_code, :roles => :app, :except => { :no_release => true } do
    on_rollback { run "rm -rf #{release_path}; true" }
    strategy.deploy!
    finalize_update
  end

  desc "Installs add-apt-repository"
  task :install_apt_repo do
    run "#{sudo} apt-get -y install python-software-properties"
    run "#{sudo} apt-get -y install libcurl3-dev libxslt-dev libxml2-dev"
    template "add-apt-repository.sh.erb", "/tmp/add-apt-repository"
    run "#{sudo} mv /tmp/add-apt-repository /usr/sbin"
    run "#{sudo} chmod o+x /usr/sbin/add-apt-repository"
    run "#{sudo} chown root:root /usr/sbin/add-apt-repository"
  end
end

