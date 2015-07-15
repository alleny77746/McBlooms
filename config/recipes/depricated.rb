def depricated(msg)
  puts "DEPRICATION WARNING: #{msg}"
end

namespace :custom do
  task :link_uploads, :roles => :app do
    depricated("You SHOULD no longer use 'uploads' folder for CKeditor uploads, PLEASE use 'system' folder")
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end
after 'deploy:update_code', 'custom:link_uploads'