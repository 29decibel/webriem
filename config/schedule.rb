# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, Rails.root.join("log/schedule.log")
set :output, "~/app/ever_schedule.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#every :day,:at=>'10:03 pm' do
#  rake "schedule:import_gpm_projects"
#end
#
#every :day,:at=>'10:30 pm' do
#  rake "schedule:import_u8_codes"
#end
#
#every :day,:at=>'10:45 pm' do
#  rake "schedule:import_u8_deps"
#end
#

every :day,:at=>'10:55 pm' do
  rake "u8_service:sync_districts"
  rake "u8_service:sync_trades"
  rake "u8_service:sync_customers"
  rake "u8_service:sync_codes"
  rake "u8_service:sync_deps"
end

every :day, :at=>'10am' do
  # rake "schedule:alert_docs_to_approve"
end

every 4.hours do
  rake "backup:mysql"
end
