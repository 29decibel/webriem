# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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
every 2.minutes do
  # command "backup perform --trigger bsqls"
  time_stamp = Time.now.strftime("%Y%m%d%I%M")
  command "mysqldump --user=root --password=china123! --databases webreim_production > ~/mysql_baks/backup_#{time_stamp}.sql"
end

# run this last
# whenever --update-crontab backup

