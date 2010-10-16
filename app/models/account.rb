class Account < ActiveRecord::Base
  validates_presence_of :name,:account_no
  validates_uniqueness_of :name,:account_no
  cattr_reader :per_page
  @@per_page = 10
end
