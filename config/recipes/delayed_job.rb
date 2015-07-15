namespace :delayed_job do
  [:start, :stop, :restart].each do |action|
    desc "#{action} the delayed_job process"
    task action, :roles => :app do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec script/delayed_job -i \"$RAILS_ENV\" #{action}"
    end
    after "deploy:#{action}", "delayed_job:#{action}"
  end
end