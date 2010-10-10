class Account < ActiveRecord::Base
  validates_presence_of :name,:account_no
  validates_uniqueness_of :name,:account_no
end
