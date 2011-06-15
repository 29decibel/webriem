default_run_options[:pty] = true

set :application, "set your application name here"
set :repository,  "git@github.com:29decibel/webriem.git"
set :user,"ldb"
set :deploy_via, :remote_cache

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "oesnow.com"                  ,:primary => true        # Your HTTP server, Apache/etc
role :app, "oesnow.com"                          # This may be the same as your `Web` server
role :db,  "oesnow.com", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  set :deploy_to,"/home/ldb/app"

  task :restart, :roles => :app do
    run "cd #{deploy_to}/current && touch tmp/restart.txt"
  end
end
