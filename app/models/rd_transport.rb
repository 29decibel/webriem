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
    def time_validate
      if start_date !=nil and end_date!=nil
        errors.add(:start_date,"请检查填写的日期或时间") if start_date>Time.now
        errors.add(:end_date,"请检查填写的日期或时间") if end_date>Time.now
      end
    end
    def amount
      fi_amount
    end
    def fcm
      return FeeCodeMatch.find_by_fee_code("03")
    end
    def project
      doc_head.project
    end
    def dep
      doc_head.afford_dep
    end
end
