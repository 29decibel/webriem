class FeeCodeMatch < ActiveRecord::Base
  belongs_to :fee
  belongs_to :ccode,:class_name=>"U8code",:foreign_key=>"ccode_id"
  belongs_to :dcode,:class_name=>"U8code",:foreign_key=>"dcode_id"
  def before_save
    self.fee_code=fee.code
  end
end
