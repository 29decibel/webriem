# RAILS_ENV=production bundle exec rake resque:work QUEUE='*' &
require "resque/tasks"

task "resque:setup" => :environment
