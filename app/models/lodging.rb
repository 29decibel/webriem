class Lodging < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  cattr_reader :per_page
  @@per_page = 10
end
