#coding: utf-8
class CustomerContact < ActiveRecord::Base
  has_paper_trail
  validates_presence_of :name,:duty,:phone
  validate :phone_no_valid

  def phone_no_valid
    errors.add(:phone,'号码不合法') if self.phone.size!=11
  end
end
