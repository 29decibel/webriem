class FeeCodeMatchesController < ApplicationController
  def index
    @fee_code_matches = FeeCodeMatch.all
  end

  def edit
    @fee_code_match = FeeCodeMatch.find(params[:id])
  end

  def update
    @fee_code_match = FeeCodeMatch.find(params[:fee_code_match][:id])
    @fee_code_match.update_attributes(params[:fee_code_match])
  end
end
