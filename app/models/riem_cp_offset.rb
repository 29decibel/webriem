class RiemCpOffset < ActiveRecord::Base
  belongs_to :reim_doc_head, :class_name => "DocHead", :foreign_key => "reim_doc_head_id"
  belongs_to :cp_doc_head, :class_name => "DocHead", :foreign_key => "cp_doc_head_id"
  #remove amount from cp
  def after_save
    cp_doc_head.update_attribute(:cp_doc_remain_amount,cp_doc_head.cp_doc_remain_amount-amount)
  end
end
