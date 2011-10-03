#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_user!,:except => [:sign_in, :sign_up]
  def get_error_messages(record)
    error_msg="\\n"
    record.errors.full_messages.each do |msg|
      error_msg<<"#{msg}\\n"
    end
    error_msg
  end

  before_filter :set_locale
 
  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  before_filter :set_mobile_format
  def set_mobile_format
    if request.format == :html && request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|Android)/]
      request.format = :mobile
    end
  end

end
