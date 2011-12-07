default_run_options[:pty] = true

set :application, "OES"
set :repository,  "git@github.com:29decibel/webriem.git"
set :user,"fin"
set :deploy_via, :remote_cache

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :port, 1066

role :web, "211.154.169.179"                  ,:primary => true        # Your HTTP server, Apache/etc
role :app, "211.154.169.179"                          # This may be the same as your `Web` server
role :db,  "211.154.169.179", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do

  desc "deploy the dev app"
  task :production do
    # you just told the cap where you what to put , and then the current,release and shared folder will created
    # for you
    set :deploy_to, "/home/fin/app"
    set :branch, "origin/doc_meta"
    set :env, "production"
    
    transaction do
      update_code
      migrate
      assets
      update_crontab
      update_data
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
    run "cd #{deploy_to}/current && RAILS_ENV=#{env} bundle exec rake db:auto:migrate"
  end

  desc "preco"
  task :assets do
    run "cd #{deploy_to}/current && bundle exec rake assets:precompile"
  end

  desc "update crontab"
  task :update_crontab do
    run "cd #{deploy_to}/current && whenever --update-crontab"
  end

  desc "Restart unicorn"
  task :restart do
    #run "cd #{deploy_to}/current && touch tmp/restart"
    run "#{try_sudo} kill -USR2 `cat #{deploy_to}/current/tmp/pids/unicorn.pid`"
  end

  desc "update"
  task :update_data do
    run "cd #{deploy_to}/current && RAILS_ENV=production bundle exec rake update:set_roles"
  end

end
