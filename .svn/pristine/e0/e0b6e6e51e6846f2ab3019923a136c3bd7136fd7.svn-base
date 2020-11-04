set :application, "wxianfeng_com"

set :repository,  "svn://106.187.47.146/wxianfeng_com"
set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm_username, 'wxianfeng'
set :scm_password, 'wxf19870104'
set :checkout, "export"

role :web, "106.187.47.146"                          # Your HTTP server, Apache/etc
role :app, "106.187.47.146"                          # This may be the same as your `Web` server
role :db,  "106.187.47.146", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_to, "/usr/local/system/www/wxianfeng_com"
# set :deploy_via, :remote_cache # 更换svn后，此代码不可使用
set :user, "wxianfeng"
set :runner, "root"

set :rake, "/usr/bin/rake"
default_run_options[:shell] = false
default_run_options[:pty] = true
set :use_sudo, true

namespace :deploy do

  task :start , :roles => :app do
    invoke_command "source /usr/local/rvm/environments/ruby-1.8.7-p334 "
    invoke_command "thin start -C /etc/thin/thin.yml"
  end

  task :stop ,:roles => :app  do
    invoke_command "killall thin" # or "thin stop -C /etc/thin/thin.yml"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    invoke_command "source /usr/local/rvm/environments/ruby-1.8.7-p334 "
    invoke_command "thin restart -C /etc/thin/thin.yml"
  end

  desc "Symlink shared configs and folders on each release."
  task :create_sync do
    run "ln -nfs #{shared_path}/public/files #{current_path}/public/files"
    run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"
  end

end

after "deploy:symlink", "deploy:create_sync"
after "deploy:create_symlink", "deploy:create_sync"
