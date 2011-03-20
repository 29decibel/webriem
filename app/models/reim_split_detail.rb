#coding: utf-8
class ReimSplitDetail < ActiveRecord::Base
  belongs_to :dep
  belongs_to :project
  belongs_to :fee
  belongs_to :doc_head
  validates_presence_of :dep_id
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  #for the vouch info
  def fcm
    return nil if doc_head ==nil
    if doc_type==9
      return FeeCodeMatch.find_by_fee_code("03")
    end
    if doc_type==11
      return FeeCodeMatch.find_by_fee_code("06")
    end
    if doc_type==13
      fee_code_match=FeeCodeMatch.find_by_fee_code("04")
      if fee
        b_fee_code_match=FeeCodeMatch.find_by_fee_code(fee.code)
      end
      return b_fee_code_match || fee_code_match
    end
  end
end
