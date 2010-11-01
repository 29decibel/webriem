class CommonRiem < ActiveRecord::Base
  belongs_to :currency
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head
  belongs_to :fee
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
