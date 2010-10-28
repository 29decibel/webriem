#coding: utf-8
class RdLodging < ActiveRecord::Base
  belongs_to :region
  belongs_to :reim_detail
  belongs_to :currency
  validate :must_have_live_person
  def must_have_live_person
    errors.add(:base,"当住宿人数大于1时，合住人必填") if people_count>1 and person_names.blank?
  end
   def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
