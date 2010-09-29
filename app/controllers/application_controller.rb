#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:except => [:sign_in, :sign_up]
  def get_error_messages(record)
    error_msg=""
    record.errors.full_messages.each do |msg|
      error_msg<<"  #{msg}"
    end
    error_msg
  end
end
