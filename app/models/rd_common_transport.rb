class RdCommonTransport < ActiveRecord::Base
    belongs_to :reim_detail  
    belongs_to :currency
    validates_presence_of :ori_amount
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
