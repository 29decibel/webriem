#coding: utf-8
class CommonController < ApplicationController
  def reset_p
    if params[:p].blank? or params[:p_c].blank?
      render "shared/errors",:locals=>{:error_msg=>"密码不能为空"}
    elsif params[:p]!=params[:p_c]
      render "shared/errors",:locals=>{:error_msg=>"两个密码不匹配"}
    elsif current_user.reset_password!(params[:p],params[:p_c])
      @message="修改密码成功"
      render "shared/show_result"
    else
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(current_user)}
    end    
  end
  def new_reset_p
    render 'devise/force_change_pw'
  end

end
