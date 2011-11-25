class ContractDoc < ActiveRecord::Base
  validates_presence_of :customer
end
