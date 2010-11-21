#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  before_filter :authenticate_user!,:except => [:sign_in, :sign_up]
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    if request.port==8012
      I18n.locale = 'en'
      logger.info "============================================="
    end
  end
  def get_error_messages(record)
    error_msg="\\n"
    record.errors.full_messages.each do |msg|
      error_msg<<"#{msg}\\n"
    end
    error_msg
  end
  layout :layout_by_resource
  def layout_by_resource
    if devise_controller?
      "devise_layout"
    else
      "application"
    end
  end
end
