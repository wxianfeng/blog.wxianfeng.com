namespace :db do
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "rm -rf #{release_path}/public/files"
    run "ln -nfs #{shared_path}/public/files #{release_path}/public/files" # or  current_path
  end

end

