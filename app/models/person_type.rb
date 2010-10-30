class PersonType < ActiveRecord::Base
  validates_uniqueness_of :name
end
