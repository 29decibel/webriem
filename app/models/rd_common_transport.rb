class RdCommonTransport < ActiveRecord::Base
    belongs_to :reim_detail  
    belongs_to :currency
    validates_presence_of :ori_amount
    validates_presence_of :start_place
    validates_presence_of :end_place
    validates_presence_of :start_time
    validates_presence_of :end_time
    validates_presence_of :currency_id
    validates_presence_of :rate
    validates_presence_of :reason
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
