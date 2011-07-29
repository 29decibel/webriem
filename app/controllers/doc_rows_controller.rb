class DocRowsController < ApplicationController
  def index
    # trim the empty doc_type
    #if params[:search] 
      #params[:search].delete 'resource_type_eq' if params[:search]['resource_type_eq'].first.blank?
      @search = DocRow.search(params[:search])
      @doc_rows = params[:search] ?  @search.all : []
      @project_pie_data = @doc_rows.group_by {|a| a.project}.map {|k,v| ["#{k.try(:name)}",v.sum(&:apply_amount).to_f]}
      @person_pie_data = @doc_rows.group_by {|a| a.person}.map {|k,v| ["#{k.try(:name)}",v.sum(&:apply_amount).to_f]}
      @apply_date_pie_data = @doc_rows.group_by {|a| a.apply_date.to_date}.map {|k,v| ["#{k.to_date}",v.sum(&:apply_amount).to_f]}
      @fee_pie_data = @doc_rows.group_by {|a| a.resource_type}.map {|k,v| ["#{resource_type_name(k)}",v.sum(&:apply_amount).to_f]}
    #end
  end

  def resource_type_name(resource_type)
    DocRow::DocResourceTypes.select {|k,v| v==resource_type}.first[0]
  end

end
