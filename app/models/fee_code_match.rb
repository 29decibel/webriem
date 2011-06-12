class FeeCodeMatch < ActiveRecord::Base
  belongs_to :fee
  belongs_to :ccode,:class_name=>"U8code",:foreign_key=>"ccode_id"
  belongs_to :dcode,:class_name=>"U8code",:foreign_key=>"dcode_id"
  validates_presence_of :fee_id,:ccode_id,:dcode_id

  before_save :set_fee_code
  def set_fee_code
    self.fee_code=fee.code
  end
end
