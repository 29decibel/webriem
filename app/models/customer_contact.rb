class CustomerContact < ActiveRecord::Base
  validates_presence_of :name,:duty,:phone
end
