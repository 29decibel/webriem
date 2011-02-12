#coding: utf-8
class VouchController < ApplicationController
  #every doc has it's own way to generate the vouch
  #i put the logic into the doc itself
  def index
  end
  #生成凭证的策略
  #1.判断该单据号是否已经生成过凭证，如果生成过则不生成，
  #并提醒删除那个凭证
  #2.如果没有生成过则获取目前最大凭证号（这个目前有问题，
  #应该是当月最大凭证号），加一，然后进行生成操作（根据
  #单据类型的不同生成的内容也不同）
  def generate
    #get doc ids
    p_doc_ids=params[:doc_ids]
    #filter the docs which already generated
    doc_ids = p_doc_ids.select do |doc_id|
      result=U8service::API.exist_vouch(doc_id)
      !result["Exist"]
    end
    #generate 
    doc_ids.each do |doc_id|
      doc=DocHead.find(doc_id)
      doc.generate_vouch if doc
    end
  end
end
