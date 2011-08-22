class Demo < ActionMailer::Base
  default :from => "mike.d.1984@gmail.com" #注意 这里的东西必须和你的smtp登陆的邮件人一致
  default_url_options[:host] = "oesnow.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.demo.notice.subject
  #
  def notice(email)
    mail :to => email
  end
end
