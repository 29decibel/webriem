require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new
#every day send a email
scheduler.cron '24 01 * * *' do
  # every day of the week at 22:00 (10pm)
  puts 'activate security system'
end