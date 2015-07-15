namespace :rails do
  set_default(:rails_secret_token) {run_locally("rake secret")}
  set_default(:rails_secret_token_dir, "config/initializers")
  set_default(:rails_secret_token_filename, "secret_token.rb")

  desc "Install rbenv, Ruby, and the Bundler gem"
  task :setup, :roles => [:app] do
    secret_token.generate
  end
  after "deploy:setup", "rails:setup"

  namespace :secret_token do
    desc "Setup Secret token"
    task :generate, :roles => [:app] do
      path = File.join(shared_path, rails_secret_token_dir, rails_secret_token_filename)
      write_token_file = remote_file_exists?(path) ? agree("secret_token.rb already exists, overwrite?") { |q| q.default="yes" } : true

      if write_token_file
        logger.trace "generated token: #{rails_secret_token}" if logger
        
        dir_path = File.join(shared_path, rails_secret_token_dir)

        run "mkdir -p #{dir_path}" unless remote_file_exists? dir_path
        template "rails_secret_token.rb.erb", path
      end
    end

    desc "Link Secret Token"
    task :link, :roles => [:app] do
      path = "#{rails_secret_token_dir}/#{rails_secret_token_filename}"
      run "ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
    end
    after 'deploy:finalize_update', 'rails:secret_token:link'

  end

end