#coding: utf-8
class RdTravel < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :fee_standard
  belongs_to :region
  belongs_to :currency
  belongs_to :region_type
  validates_presence_of :ori_amount
  validates_presence_of :days
  validates_presence_of :reason
  validates_presence_of :rate
  validates_presence_of :currency_id
  validate :must_have_a_place
   def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
  def must_have_a_place
    errors.add(:base,"出差地点或者其他地点必须录入一个") if region_id==nil and custom_place.blank?
  end
  #def before_validation
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'before validateing travel================='
  #end
  #def after_validation
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'after validate doc travel================='
  #end
  #def before_save
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'before save doc travel================='
  #end
  #def after_save
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'after save  travel=================doc'
  #end
  #def before_update
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'before update d travel=================oc'
  #end
  #def around_update
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'around update doc travel================='
  #end
  #def after_update
  #  clogger=Logger.new ('aaa.txt')
  #  clogger.info 'after update travel================='
  #end
end
