#coding: utf-8
class CommonController < ApplicationController
  def reset_p
    current_user.reset_password!(params[:p],params[:p_c])
  end

end
