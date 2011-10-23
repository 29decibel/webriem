class DocRelation < ActiveRecord::Base
  belongs_to :doc_row_meta_info
  belongs_to :doc_meta_info

  def doc_row_attrs
    if !self[:default_fields].blank?
      self[:default_fields].split(',')
    else
      eval(doc_row_meta_info.name).column_names.reject{|cn|%w(id doc_head_id sequence created_at updated_at).include? cn} if doc_row_meta_info
    end
  end
end
