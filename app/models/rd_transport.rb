class RdTransport < ActiveRecord::Base
    belongs_to :reim_detail
    belongs_to :transportation, :class_name => "Transportation", :foreign_key => "transportation_id"
    belongs_to :currency
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
