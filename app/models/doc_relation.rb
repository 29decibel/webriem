class DocRelation < ActiveRecord::Base
  belongs_to :doc_row_meta_info
  belongs_to :doc_meta_info

  scope :multi,lambda {|multi| where('multiple=?',multi)}


  def doc_row_attrs
    if !self[:doc_row_attrs].blank?
      self[:doc_row_attrs].split(',').map{|a|a.strip}
    else
      eval(doc_row_meta_info.name).column_names.reject{|cn|%w(id doc_head_id sequence created_at updated_at).include? cn} if doc_row_meta_info
    end
  end

  def doc_row_attrs=(value)
    if value.is_a? Array
      self[:doc_row_attrs] = value.join(',')
    else
      self[:doc_row_attrs] = value
    end
  end

  def print_attrs
    self[:print_attrs] ? self[:print_attrs].split(',').map{|a|a.strip} : []
  end
end
