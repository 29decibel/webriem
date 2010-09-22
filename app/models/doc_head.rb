class DocHead < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :person
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  blongs_to_name_attr :person
  #has many recivers and cp_doc_details
  has_many :recivers, :class_name => "Reciver", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :cp_doc_details, :class_name => "CpDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :reim_details,:class_name=>"ReimDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rec_notice_details,:class_name=>"RecNoticeDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  #其实这些都只有一条，但是为了方便这样写
  has_many :inner_remittances, :class_name => "InnerRemittance", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_many :inner_transfers, :class_name => "InnerTransfer", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_many :inner_cash_draws, :class_name => "InnerCashDraw", :foreign_key => "doc_head_id",:dependent=>:destroy
  #======================================================================
  accepts_nested_attributes_for :recivers,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :cp_doc_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :reim_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rec_notice_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  #here is the samn reason for 
  accepts_nested_attributes_for :inner_remittances ,:reject_if => lambda { |a| a[:out_account].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :inner_transfers ,:reject_if => lambda { |a| a[:out_account].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :inner_cash_draws ,:reject_if => lambda { |a| a[:account_id].blank? }, :allow_destroy => true
end
