require "msg"
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:except => [:sign_in, :sign_up]
end
