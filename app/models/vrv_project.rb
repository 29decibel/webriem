#coding: utf-8
class VrvProject < ActiveRecord::Base
  has_one :customer_contact
  has_one :network_condition
  has_many :competitors
  has_many :busi_communications
  has_many :tech_communications
  has_one :product_test
  has_one :bill_prepare
  has_one :contract_predict
  has_one :bill_stage
  has_one :bill_after
  has_many :implement_activities

  SCALE = %w(150-300)
  AMOUNT = %w(10万以下)

  validates :scale,:inclusion => SCALE
  validates :amount,:inclusion => AMOUNT

  accepts_nested_attributes_for :customer_contact, :allow_destroy => true

  after_initialize :set_contact

  def star
    human_star || system_star
  end
  #未提交，审核中，星级状态，中标状态，未中标状态，报废
  state_machine :state, :initial => :un_submit do
    event :submit do
      transition [:rejected,:un_submit] => :processing
    end
    event :reject do
      transition [:processing] => :rejected
    end
    event :approve do
      transition [:processing] => :star
    end
    event :win do
      transition [:star] => :bid_success
    end
    event :lost do
      transition [:star] => :bid_fail
    end
    event :disable do
      transition [:star] => :invalide
    end
  end

  private
  def set_contact
    if !customer_contact
      self.customer_contact = CustomerContact.new
    end
  end
end
