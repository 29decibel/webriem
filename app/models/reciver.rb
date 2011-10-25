#coding: utf-8
class Reciver < ActiveRecord::Base

  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :settlement, :class_name => "Settlement", :foreign_key => "settlement_id"
  belongs_to :supplier

  validates_presence_of :amount
  validates_presence_of :settlement_id
  validates_presence_of :company ,:if => Proc.new{|r| r.settlement!=nil and r.settlement.code == '02' and r.supplier==nil }
  validates_presence_of :bank_no ,:if => Proc.new{|r| r.settlement!=nil and r.settlement.code == '02' }
  validates_presence_of :bank ,:if => Proc.new{|r| r.settlement!=nil and r.settlement.code == '02' }

  after_initialize :init_settlement

  def init_settlement
    return unless self.new_record?
    sc = SystemConfig.find_by_key 'default_settlement'
    if sc and sc.value
      default_settlement = Settlement.find_by_code(sc.value)
      self.settlement = default_settlement if default_settlement
    end
  end

  def init_from_person(person)
    self.company = person.name
    self.bank = person.bank
    self.bank_no = person.bank_no
  end

  #add supplier 
  def company_name
    if supplier
      supplier.name
    else
      self.company
    end
  end
  #minus amount
  def reduce_amount(amount)
    self.fi_amount=self.amount if self.fi_amount==nil
    self.hr_amount=self.amount if self.hr_amount==nil
    #do the math
    self.amount-=amount
    self.fi_amount-=amount
    self.hr_amount-=amount
    self.save
  end
  def add_amount(amount)
    self.fi_amount=self.amount if self.fi_amount==nil
    self.hr_amount=self.amount if self.hr_amount==nil
    #do the math
    self.amount+=amount
    self.fi_amount+=amount
    self.hr_amount+=amount
    self.save 
  end
end
