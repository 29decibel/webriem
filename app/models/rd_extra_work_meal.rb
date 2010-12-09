#coding: utf-8
class RdExtraWorkMeal < ActiveRecord::Base
    belongs_to :reim_detail 
    belongs_to :currency 
    enum_attr :is_sunday, [["是",0],["否", 1]]
    validates_presence_of :start_time
    validates_presence_of :end_time
    validates_presence_of :reason
    validates_presence_of :currency_id
    validates_presence_of :rate
    validates_presence_of :ori_amount
    default_scope :order => 'start_time ASC'
    def after_initialize
      if self.new_record?
        self.currency=Currency.find_by_code("RMB")
        if self.currency
          self.rate=self.currency.default_rate
        end
      end
    end
    validate :time_validate
    def time_validate
      if start_time !=nil and end_time!=nil
        errors.add(:start_time,"请检查填写的日期或时间") if start_time>Time.now
        errors.add(:end_time,"请检查填写的日期或时间") if end_time>Time.now
      end
    end
end
