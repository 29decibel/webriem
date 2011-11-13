#coding: utf-8
class DocAmountChange < ActiveRecord::Base
  belongs_to :person
  validate :can_not_greater

  def resource
    eval(self.resource_class).find(self.resource_id)
  end

  class << self
    def final_amount(resource)
      last_change = DocAmountChange.where("resource_class=? and resource_id=?",resource.class.name,resource.id).last
      last_change.try(:new_amount) || resource.apply_amount
    end
  end

  private
  def can_not_greater
    previous = DocAmountChange.where("resource_class=? and resource_id=?",self.resource_class,self.resource_id).last
    amount = previous.try(:new_amount) || resource.apply_amount || 0
    errors.add(:base,'调整金额不能大于前一个金额') if self.new_amount>=amount
  end
end