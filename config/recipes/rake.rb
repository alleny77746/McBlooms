namespace :db do
   desc "Seed the #{rails_env} Database"
    task :seed do
      puts "\n\n=== Seeding the #{rails_env} Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
    end
end