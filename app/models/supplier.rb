class Supplier < ActiveRecord::Base
  def to_s
    name
  end
  def other_info
    "#{bank},#{bank_no}"
  end
end
