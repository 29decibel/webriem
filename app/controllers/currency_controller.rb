class CurrencyController < ApplicationController
  def show
    currency = Currency.find params[:id]
    respond_to do |wants|
      wants.json { render :json=>currency}
    end
  end
end
