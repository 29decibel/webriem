class U8District < ActiveRecord::Base
  validates :name,:uniqueness => true,:presence=>true
  validates :code,:uniqueness => true,:presence=>true
end

