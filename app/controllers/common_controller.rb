#coding: utf-8
class CommonController < ApplicationController
  def reset_p
    if params[:p].blank? or params[:p_c].blank?
      render "shared/errors",:locals=>{:error_msg=>"#{I18n.t('controller_msg.password_not_none')}"}
    elsif params[:p]!=params[:p_c]
      render "shared/errors",:locals=>{:error_msg=>"#{I18n.t('controller_msg.two_pass_not_equal')}"}
    elsif current_user.reset_password!(params[:p],params[:p_c])
      @message="#{I18n.t('controller_msg.update_pass_ok')}"
      render "shared/show_result"
    else
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(current_user)}
    end    
  end
  def new_reset_p
    render 'devise/force_change_pw'
  end

end