class FeeCodeMatchesController < ApplicationController
  def index
    @fee_code_matches = FeeCodeMatch.all
  end

  def edit
    @fee_code_match = FeeCodeMatch.find(params[:id])
    render "basic_setting/edit",:locals=>{:resource=>@fee_code_match}
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
    render "basic_setting/new",:locals=>{:resource=>@fee_code_match}
  end
  def create
    @fee_code_match = FeeCodeMatch.new(params[:fee_code_match])
    if !@fee_code_match.save
      render "basic_setting/new",:locals=>{:resource=>@fee_code_match,:resources=>@fee_code_matches}
    else
      @fee_code_matches=FeeCodeMatch.all
      render "basic_setting/create",:locals=>{:resource=>@fee_code_match,:resources=>@fee_code_matches}
    end
  end
  def destroy
    @fee_code_match = FeeCodeMatch.find(params[:id])
    @delete_id=@fee_code_match.id
    @fee_code_match.destroy
    render "basic_setting/destroy",:locals=>{:resource=>@fee_code_match}
  end
  def show
    
  end
end
