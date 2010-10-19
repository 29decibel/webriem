class RiemCpOffset < ActiveRecord::Base
  belongs_to :reim_doc_head, :class_name => "DocHead", :foreign_key => "reim_doc_head_id"
  belongs_to :cp_doc_head, :class_name => "DocHead", :foreign_key => "cp_doc_head_id"
end
