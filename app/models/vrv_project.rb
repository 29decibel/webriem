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

  def star
    human_star || system_star
  end

  state_machine :state, :initial => :un_submit do
    event :submit do
      transition [:rejected,:un_submit] => :processing
    end
    event :reject do
      transition [:processing] => :rejected
    end
    event :approve do
      transition [:processing] => :approved
    end
  end
end
