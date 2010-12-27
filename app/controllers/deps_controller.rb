#coding: utf-8
class DepsController < ApplicationController
  # GET /deps
  def index
    #redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Dep",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
  end
  
  # GET /currencies/new
  def new
    @dep = Dep.new
  end
  
  # GET /deps/1
  #显示所有的部门在这里啊
  def show
    @dep = Dep.find(params[:id])
    if @dep.parent_dep==nil
      @parent_dep="#{I18n.t('controller_msg.no_parent_dep')}"
    else
      @parent_dep=@dep.parent_dep.name
    end
  end

  # POST /deps
  def create
    @dep = Dep.new(params[:dep])
    if @dep.save
      @message="#{I18n.t('controller_msg.create_ok')}"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@dep)}
    end
  end

  # PUT /deps/1
  def update
    @dep = Dep.find(params[:id])
    if @dep.update_attributes(params[:dep])
      @message="#{I18n.t('controller_msg.update_ok')}"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@dep)}
    end
  end

  # DELETE /deps/1
  def destroy
    @dep = Dep.find(params[:id])
    @dep.destroy
    redirect_to(deps_url)
  end
end
