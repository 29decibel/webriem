class Supplier < ActiveRecord::Base
  validates_presence_of :bank,:bank_no
  validates_uniqueness_of :code
  def to_s
    name
  end
  def other_info
    "#{bank},#{bank_no}"
  end
end
