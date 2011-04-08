#coding: utf-8
class DocOffSetController < ApplicationController
  def index
    @docs_by_person={}
    #[:riem_docs] [:cp_docs]
    persons=Person.where("name like ?","%#{params[:person]}%").all
    Person.all.each do |p|
      dbps=docs_by_person(p)
      if dbps[:riem_docs].count>0 and dbps[:cp_docs].count>0
        @docs_by_person[p]=docs_by_person(p)
      end
    end
  end
  def search  
    @docs_by_person={}
    #[:riem_docs] [:cp_docs]
    persons=Person.where("name like ?","%#{params[:person]}%").all
    persons.each do |p|
      dbps=docs_by_person(p)
      if dbps[:riem_docs].count>0 and dbps[:cp_docs].count>0
        @docs_by_person[p]=docs_by_person(p)
      end
    end
  end
  def remove_offset
    offset=RiemCpOffset.find(params[:id])
    #add cp remain amount back
    new_amount=offset.cp_doc_head.cp_doc_remain_amount+offset.amount
    offset.cp_doc_head.update_attribute(:cp_doc_remain_amount,new_amount)
    #add recivers back
    offset.reim_doc_head.recivers.first.add_amount(offset.amount)
    @person=offset.cp_doc_head.person
    offset.destroy
    @dbp=docs_by_person(@person)
  end
  def do_offset
    riem_docs=[]
    cp_docs=[]
    params[:rm].each do |r,v|
      next if v["amount"].to_f==0
      riem_docs<<{:doc=>DocHead.find(v["doc_id"]),:amount=>v["amount"].to_f}
    end
    params[:cp].each do |r,v|
      next if v["amount"].to_f==0
      cp_docs<<{:doc=>DocHead.find(v["doc_id"]),:amount=>v["amount"].to_f}
    end
    #check input is ok
    validate_info=validate(riem_docs,cp_docs)
    if !validate_info[:pass]
      render "shared/errors",:locals=>{:error_msg=>validate_info[:error_msg]}
    else
      RiemCpOffset.do_offset(riem_docs,cp_docs)
      @person=Person.find(params[:person_id])
      @dbp=docs_by_person(@person)
    end
  end
  private
  def validate(riem_docs,cp_docs)
    error_msg=""
    pass=true
    r_sum=riem_docs.sum {|d| d[:amount]}
    c_sum=cp_docs.sum {|d| d[:amount]}
    if r_sum!=c_sum
      pass=false
      error_msg="借款冲抵总金额(#{c_sum})和报销冲抵总金额(#{r_sum})不等"
    end
    if riem_docs.count==0 || cp_docs.count==0
      pass=false
      error_msg="请填写冲抵金额"
    end
    #不能超过报销金额
    if riem_docs.any? {|d| d[:doc].reciver_amount<d[:amount]}
      pass=false
      error_msg="请检查报销单据的冲抵金额，冲抵金额不能大于报销金额"
    end
    #不能超过剩余冲抵金额
    if cp_docs.any? {|d| d[:doc].cp_doc_remain_amount<d[:amount]}
      pass=false
      error_msg="请检查借款单据的冲抵金额，冲抵金额不能大于单据的剩余冲抵金额"
    end
    {:pass=>pass,:error_msg=>error_msg}
  end
  def docs_by_person(p)
    riem_docs=DocHead.where("person_id = ? and doc_type between 9 and 13 and doc_state>=2",p.id).all
    cp_docs=DocHead.where("person_id = ? and doc_type =1 and doc_state=3 and cp_doc_remain_amount>0",p.id).all
    offsets=RiemCpOffset.joins(:reim_doc_head).where("doc_heads.person_id=? and doc_heads.doc_state>=2",p.id)
    {:riem_docs=>riem_docs,:cp_docs=>cp_docs,:offsets=>offsets}
  end
end
