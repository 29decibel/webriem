class DocRowsController < ApplicationController
  def index
    # trim the empty doc_type
    #if params[:search] 
      #params[:search].delete 'resource_type_eq' if params[:search]['resource_type_eq'].first.blank?
      @search = DocRow.search(params[:search])
      @doc_rows = @search.all
    #end
  end

end
