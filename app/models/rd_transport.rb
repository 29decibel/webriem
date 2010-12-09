#coding: utf-8
class RdTransport < ActiveRecord::Base
    belongs_to :reim_detail
    belongs_to :transportation, :class_name => "Transportation", :foreign_key => "transportation_id"
    belongs_to :currency
    validates_presence_of :ori_amount
    validates_presence_of :start_date
    validates_presence_of :end_date
    validates_presence_of :start_position
    validates_presence_of :end_position
    validates_presence_of :transportation_id
    validates_presence_of :reason
    validates_presence_of :rate
    validates_presence_of :currency_id
    default_scope :order => 'start_date ASC'
    validate :time_validate
    def after_initialize
      if self.new_record?
        self.currency=Currency.find_by_code("RMB")
        if self.currency
          self.rate=self.currency.default_rate
        end
      end
    end
    def time_validate
      if start_date !=nil and end_date!=nil
        errors.add(:start_date,"请检查填写的日期或时间") if start_date>Time.now
        errors.add(:end_date,"请检查填写的日期或时间") if end_date>Time.now
      end
    end
end
