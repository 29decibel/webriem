namespace :backup do
  desc "backup mysqls"
  task :mysql do
    time_stamp = Time.now.strftime("%Y%m%d%I%M")
    back_up_dir = '/home/fin/oes_backup'
    FileUtils.mkdir(back_up_dir) unless Dir.exist?(back_up_dir)
    system "mysqldump --user=root --password=clearvrv --databases oes_production > #{back_up_dir}/mysqlbackup_#{time_stamp}.sql"
  end
end
