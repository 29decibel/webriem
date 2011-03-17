#coding: utf-8
class RdExtraWorkMeal < ActiveRecord::Base
    belongs_to :reim_detail 
    belongs_to :currency 
    enum_attr :is_sunday, [["否", 1],["是",0]]
    validates_presence_of :start_time
    validates_presence_of :end_time
    validates_presence_of :reason
    validates_presence_of :currency_id
    validates_presence_of :rate
    validates_presence_of :ori_amount
    default_scope :order => 'start_time ASC'
    validate :time_validate
    def time_validate
      if start_time !=nil and end_time!=nil
        errors.add(:start_time,"请检查填写的日期或时间") if start_time>Time.now
        errors.add(:end_time,"请检查填写的日期或时间") if end_time>Time.now
      end
    end
    def amount
      fi_amount
    end
    def fcm
      return FeeCodeMatch.find_by_fee_code("0601")
    end
    def project
      doc_head.project
    end
    def dep
      doc_head.afford_dep
    end
end
