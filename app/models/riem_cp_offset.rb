#coding: utf-8
class RiemCpOffset < ActiveRecord::Base
  belongs_to :reim_doc_head, :class_name => "DocHead", :foreign_key => "reim_doc_head_id"
  belongs_to :cp_doc_head, :class_name => "DocHead", :foreign_key => "cp_doc_head_id"
  validate :amount_lt_cp_remain
  #remove amount from cp
  after_save :update_amount
  def update_amount
    cp_doc_head.update_attribute(:cp_doc_remain_amount,cp_doc_head.cp_doc_remain_amount-amount)
  end
  def amount_lt_cp_remain
    errors.add(:base,"冲抵金额不能大于借款单上的剩余冲抵金额") if (amount>cp_doc_head.cp_doc_remain_amount)
  end
  #策略
  #拿一个riem和一个cp比较金额，选出最小的
  #生成一条冲抵记录（本对象）
  #将riem的付款金额和cp的剩余冲抵金额都减去这个金额，这个值也减去这个数
  #淘汰掉为0的，继续做这件事，直到两个队列为空为止
  def self.do_offset(riem_docs,cp_docs)
    return if (riem_docs.count==0 or cp_docs.count==0) #说明结束了
    minus_amount=(riem_docs[0][:amount] <= cp_docs[0][:amount] ) ? riem_docs[0][:amount] : cp_docs[0][:amount]
    rcp=RiemCpOffset.new
    rcp.reim_doc_head=riem_docs[0][:doc]
    rcp.cp_doc_head=cp_docs[0][:doc]
    rcp.amount=minus_amount
    rcp.save
    #reduce recivers amount
    riem_docs[0][:doc].reduce_recivers_amount(minus_amount)
    #self reduce
    riem_docs[0][:amount]-=minus_amount
    cp_docs[0][:amount]-=minus_amount
    #filter docs whose off_amount is 0
    riem_docs=riem_docs.delete_if {|d| d[:amount]==0 }
    cp_docs=cp_docs.delete_if {|d| d[:amount]==0 }
    #循环进行
    RiemCpOffset.do_offset(riem_docs,cp_docs)
  end
end
