default_run_options[:pty] = true

set :application, "OES"
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

  desc "deploy the dev app"
  task :dev do
    # you just told the cap where you what to put , and then the current,release and shared folder will created
    # for you
    set :deploy_to, "/home/ldb/dev/oes"
    set :branch, "origin/dev"
    set :env, "production"
    
    transaction do
      update_code
      migrate
    end

    restart
  end

  task :update_code do
    run "cd #{deploy_to}/current; git fetch origin; git reset --hard #{branch}"
    run "cd #{deploy_to}/current/public && ln -nfs #{deploy_to}/shared/uploads/ uploads"
    run "cd #{deploy_to}/current && rm config/database.yml && ln -s #{deploy_to}/shared/database.yml config/database.yml"
  end

  desc "Rake database"
  task :migrate do
    run "cd #{deploy_to}/current && bundle install --deployment"
    run "cd #{deploy_to}/current && RAILS_ENV=#{env} bundle exec rake db:schema:load"
  end

  desc "Restart unicorn"
  task :restart do
    run "#{try_sudo} kill -USR2 `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end

end
