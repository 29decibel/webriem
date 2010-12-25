#trigger rake
if Rails.env=="production"
  system "rake RAILS_ENV=#{Rails.env} jobs:work --trace >>~//send_mail_log.txt &"
end