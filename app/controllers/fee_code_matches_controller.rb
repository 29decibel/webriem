class FeeCodeMatchesController < ApplicationController
  def index
    @resources=FeeCodeMatch.all
    @model_s_name="fee_code_match"
    @model_p_name="fee_code_matches"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @fee_code_match = FeeCodeMatch.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@fee_code_match}}
    end
  end

  def update
    @fee_code_match = FeeCodeMatch.find(params[:fee_code_match][:id])
    if !@fee_code_match.update_attributes(params[:fee_code_match])
      render "basic_setting/edit",:locals=>{:resource=>@fee_code_match}
    else
      render "basic_setting/update",:locals=>{:resource=>@fee_code_match}
    end
  end
  def new
    @fee_code_match = FeeCodeMatch.new
    respond_to do |format|
      format.js {render "basic_setting/new",:locals=>{:resource=>@fee_code_match}}
    end
  end
  def create
    @fee_code_match = FeeCodeMatch.new(params[:fee_code_match])
    if !@fee_code_match.save
      render "basic_setting/new",:locals=>{:resource=>@fee_code_match,:resources=>@fee_code_matches}
    else
      redirect_to index
    end
  end
  def destroy
    @fee_code_match = FeeCodeMatch.find(params[:id])
    @fee_code_match.destroy
    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@fee_code_match}}
    end
  end
  def show
    
  end
end
