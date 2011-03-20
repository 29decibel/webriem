class FeeCodeMatchesController < ApplicationController
  def index
    @fee_code_matches = FeeCodeMatch.all
  end

  def edit
    @fee_code_match = FeeCodeMatch.find(params[:id])
  end

  def update
    @fee_code_match = FeeCodeMatch.find(params[:fee_code_match][:id])
    if !@fee_code_match.update_attributes(params[:fee_code_match])
      render "edit"
    end
  end
  def new
    @fee_code_match = FeeCodeMatch.new
  end
  def create
    @fee_code_match = FeeCodeMatch.new(params[:fee_code_match])
    if !@fee_code_match.save
      render "new"
    end
    @fee_code_matches=FeeCodeMatch.all
  end
  def destroy
    @fee_code_match = FeeCodeMatch.find(params[:id])
    @delete_id=@fee_code_match.id
    @fee_code_match.destroy
  end
  def show
    
  end
end
