#coding: utf-8
class VouchesController < InheritedResources::Base
  before_filter :authenticate_user!
  belongs_to :doc_head
  #every doc has it's own way to generate the vouch
  #i put the logic into the doc itself

  def index
    index!
    if @doc_head.vouches.count==0
      @doc_head.generate_vouch_v2
    end
  end

  def update
    update! do
      redirect_to doc_head_vouches_path(@doc_head)
      return
    end
  end

  def rg_vouch
    @doc=DocHead.find(params[:doc_id])
    @doc.rg_vouches
  end

  def g_u8
    @message=""
    @doc=DocHead.find(params[:doc_id])
    #first at all we check wether the ccode is the end code
    vouch_valide = @doc.vouches.all? {|v| v.code and v.code.bend }
    if !vouch_valide
      @message="有分录没有设置科目或所设置的科目非末级，请检查"
    else
      #首先校验看时候已经生成过了，根据单据号
      if @doc.exist_vouch?
        @message="该单据在U8中已经生成过凭证，请先删除凭证再重复生成"
      else
        #记住这里要计算一下当前系统中当月的最大单据号，然后赋值给v
        #get current max vouch no and plus 1 as current vouch no
        vouch_no="test in dev"
        if RAILS_ENV=="production"
          vouch_no=Sk.max_ino_id + 1
        end
        #begin generate
        @doc.vouches.each do |v|
          v.ino_id=vouch_no
          msg=Sk.generate_vouch_from_doc v
          if msg!="-1"
            @message<<"分录号#{v.inid}：#{get_specific_error msg} \n"
            return
          end
        end
      end
    end
  end

  def get_specific_error(msg)
    message=msg
    if msg.include? '冲突' and msg.include? 'cDepCode'
      message="部门在U8系统不存在，请修改凭证或默认设置"
    end
    if msg.include? '冲突' and msg.include? 'cPersonCode'
      message="人员在U8系统不存在，请修改凭证或默认设置"
    end
    message
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
      # filter exists
      !Sk.exist_vouch(doc_id)
    end
    #generate 
    doc_ids.each do |doc_id|
      doc=DocHead.find(doc_id)
      doc.generate_vouch if doc
    end
  end

end
