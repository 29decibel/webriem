#coding: utf-8
module DocHeadVouch
  #判断是否单据已经生成过凭证
  def exist_vouch?
    exist_info=nil
    begin
      exist_info=U8service::API.exist_vouch doc_no
    rescue Exception=>msg
      Rails.logger.error "u8 service exist vouch error ,error msg is #{msg}"
      return false
    end
    return exist_info["Exist"]
  end
  #vouch infos
  #this is a massive method which contains a lot of logic 
  #and 'if else'
  #把所有的获取fee_code_match的逻辑都放在各自的子条目中
  #保证每个子条目都有一个fee_code_match,project,dep
  def rg_vouches
    #分摊的逻辑
    if is_split==1 and [9,11,13].include? doc_type
      #加班和差旅基本相同，只是默认的科目不同
      self.vouches.clear
      fee_code_match=nil
      if doc_type==9
        fee_code_match=FeeCodeMatch.find_by_fee_code("03")
      end
      if doc_type==11
        fee_code_match=FeeCodeMatch.find_by_fee_code("06")
      end
      if doc_type==13
        fee_code_match=FeeCodeMatch.find_by_fee_code("04")
        b_fee_code_match=fee_code_match #point to default
      end
      init_count=1
      benefits_codes=[]
      #n debit
      reim_split_details.each do |s|
        #如果是福利费用再变化一次科目，并记录
        fcm=fee_code_match
        if doc_type==13 and s.fee
          b_fee_code_match=FeeCodeMatch.find_by_fee_code(s.fee.code)
          if b_fee_code_match
            benefits_codes<<b_fee_code_match.ccode
            fcm=b_fee_code_match
          end
        end
        vj=get_v ({
          :inid=>"#{init_count}",
          :code=>fcm.dcode,# dai kemu
          :md=>s.percent_amount,:md_f=>s.percent_amount,
          :dep=>s.dep,# dep code
          :project=>s.project,#project code
          :ccode_equal=>fcm.ccode.to_s,
          :s_cdept_id=>fcm.ddep,
          :doc_no=>cdigest_info(fcm),
          :s_cperson_id=>fcm.dperson})
        self.vouches.create(vj)
        init_count=init_count+1
      end
      #1 credit
      vd=get_v ({
        :inid=>"#{init_count}",
        :code=>fee_code_match.ccode,# dai kemu
        :mc=>total_amount,:mc_f=>total_amount,
        :dep=>nil,# dep code
        :project=>nil,#project code
        :s_cdept_id=>fee_code_match.cdep,
        :doc_no=>cdigest_info(fee_code_match),
        :s_cperson_id=>fee_code_match.cperson,
        :ccode_equal=>(doc_type==13 ? benefits_codes.join(",") : fee_code_match.ccode.to_s)})
      self.vouches.create(vd)
    else
      #借款或付款单据【只生成一个借和一个贷，】
      ###################################################################################################
      if doc_type==1 or doc_type==2
        #get the two code
        if doc_type==1
          fee_m_code=FeeCodeMatch.find_by_fee_code("07") 
        else
          fee_m_code=FeeCodeMatch.find_by_fee_code("08")
        end
        self.vouches.clear
        #n条借方
        jcount=1
        self.cp_doc_details.each do |cp|
           vj=get_v ({:inid=>"#{jcount}",
           :code=>fee_m_code.dcode,
           :md=>total_amount,:md_f=>total_amount,
           :dep=>cp.dep,
           :project=>cp.project,
           :doc_no=>cdigest_info(fee_m_code),
           :s_cdept_id=>fee_m_code.ddep,
           :s_cperson_id=>fee_m_code.dperson,
           :ccode_equal=>fee_m_code.ccode.to_s})
          self.vouches.create(vj)
          jcount+=1
        end
        #1个贷方
        vd=get_v ({
          :inid=>"#{jcount}",
          :code=>fee_m_code.ccode,# dai kemu
          :md=>"0",:mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code
          :project=>nil,#project code
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.create(vd)
      end
      #差旅费用【只生成一个借和一个贷，】
      ###################################################################################################
      if doc_type==9
        #get the two code
        fee_m_code=FeeCodeMatch.find_by_fee_code("03")
        vj=get_v ({:inid=>"1",
          :code=>fee_m_code.dcode,
          :md=>total_amount,:md_f=>total_amount,
          :dep=>afford_dep,
          :project=>project,
          :person=>nil,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cdept_id=>fee_m_code.ddep,
          :s_cperson_id=>fee_m_code.dperson,
          :ccode_equal=>fee_m_code.ccode.to_s})
        vd=get_v ({
          :inid=>"2",
          :code=>fee_m_code.ccode,# dai kemu
          :md=>"0",:mc=>total_amount,:mc_f=>total_amount,
          :dep=>afford_dep,# dep code
          :project=>project,#project code
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.clear
        self.vouches.create(vj)
        self.vouches.create(vd)
      end
      #交际费用，没有分摊，每个明细都是一条借(已经对相同的项目和部门的分录进行了合并)
      ###################################################################################################
      if doc_type==10
        self.vouches.clear
        fee_m_code=FeeCodeMatch.find_by_fee_code("02")
        init_count=1
        #n 条借
        #根据新的需求，如果有部门项目相同的则进行合并，所以部门加项目是唯一的key
        combined_wms={} #先把合并后的放进这个结构，然后再进行凭证生成
        #这个结构为 key=>"#{project_id}__#{dep_id}",:value=>{:project=>project,:dep=>dep,:amount=>....}
        rd_work_meals.each do |w_m|
          key="#{w_m.project_id}__#{w_m.dep_id}"
          if combined_wms.include? key
            combined_wms[key][:amount]+=w_m.apply_amount
          else
            combined_wms[key]={:project=>w_m.project,:dep=>w_m.dep,:amount=>w_m.amount }
          end
        end
        #这里才进行真正的生成
        combined_wms.each do |k,c_w_m|
          vj=get_v ({
            :inid=>"#{init_count}",
            :code=>fee_m_code.dcode,# dai kemu
            :md=>c_w_m[:amount],:md_f=>c_w_m[:amount],
            :dep=>c_w_m[:dep],# dep code
            :project=>c_w_m[:project],#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code),
            :s_cdept_id=>fee_m_code.ddep,
            :s_cperson_id=>fee_m_code.dperson,
            :ccode_equal=>fee_m_code.ccode.to_s})
          self.vouches.create(vj)
          init_count=init_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{init_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.create(vd)
      end
      #加班费用，一个贷，两个借
      ###################################################################################################
      if doc_type==11
        self.vouches.clear
        fee_m_code_meal=FeeCodeMatch.find_by_fee_code("0601")
        fee_m_code_car=FeeCodeMatch.find_by_fee_code("0602")
        jb_fcms=[]
        #1个或2个借
        inid_count=1
        if rd_extra_work_meals.count>0
          jb_fcms<<fee_m_code_meal
          total=0
          rd_extra_work_meals.each {|w_m| total=w_m.fi_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_meal.dcode,# dai kemu
            :md=>total,:md_f=>total,
            :dep=>afford_dep,# dep code
            :project=>project,#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code_meal),
            :s_cdept_id=>fee_m_code_meal.ddep,
            :s_cperson_id=>fee_m_code_meal.dperson,
            :ccode_equal=>fee_m_code_meal.ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        if rd_extra_work_cars.count>0
          jb_fcms<<fee_m_code_car
          total=0
          rd_extra_work_cars.each {|w_c| total=w_c.fi_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_car.dcode,# dai kemu
            :md=>total,:md_f=>total,
            :dep=>afford_dep,# dep code
            :project=>project,#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code_car),
            :s_cdept_id=>fee_m_code_car.ddep,
            :s_cperson_id=>fee_m_code_car.dperson,
            :ccode_equal=>fee_m_code_car.ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code_meal.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code_meal.cdep,
          :doc_no=>cdigest_info(jb_fcms),
          :s_cperson_id=>fee_m_code_meal.cperson,
          :ccode_equal=>fee_m_code_meal.dcode.to_s})
        self.vouches.create(vd)
      end
      #福利费用(已经根据fee project和dep进行了合并)
      ###################################################################################################
      if doc_type==13
        self.vouches.clear
        vd_codes=[]
        fee_m_code=FeeCodeMatch.find_by_fee_code("04")
        fl_fcms=[]
        #n条借方
        #cobined hash
        combined_benefits={}
        rd_benefits.each do |b|
          #get fee code info
          if b.fee
            fee_m_code=FeeCodeMatch.find_by_fee_code(b.fee.code)
            fl_fcms<<fee_m_code if !fl_fcms.include? fee_m_code
          end
          vd_codes<<fee_m_code.dcode.to_s
          #到这里的时候已经确定了fee，用fee+dep+project作为key进行合并
          combine_key="#{fee_m_code.id}__#{b.dep.id}__#{b.project.id}"
          if combined_benefits[combine_key]
            combined_benefits[combine_key][:amount]+=b.fi_amount
          else
            combined_benefits[combine_key]={:dep=>b.dep,:project=>b.project,:amount=>b.fi_amount,:fee=>fee_m_code}
          end
        end
        #这里进行真正的生成
        inid_count=1
        combined_benefits.each do |k,b|
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>b[:fee].dcode,# dai kemu
            :md=>b[:amount],:md_f=>b[:amount],
            :dep=>b[:dep],# dep code
            :project=>b[:project],#project code
            :person=>nil,
            :doc_no=>cdigest_info(b[:fee]),
            :s_cdept_id=>b[:fee].ddep,
            :s_cperson_id=>b[:fee].dperson,
            :ccode_equal=>b[:fee].ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fl_fcms),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>vd_codes.join(',')})
        self.vouches.create(vd)
      end
      #普通费用
      ###################################################################################################
      if doc_type==12
        self.vouches.clear
        #default fee code match
        fee_m_code=FeeCodeMatch.find_by_fee_code("01")
        inid_count=1
        vd_codes=[]
        fcms=[] #记录可能的费用类型
        #-----------------------------------------------------------------------
        #普通费用n条借
        if common_riems.count>0
          comb_info={}
          fcms<<fee_m_code
          #先进行合并
          common_riems.each do |r|
            #get fee code info
            vd_codes<<fee_m_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_m_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_m_code),
              :s_cdept_id=>fee_m_code.ddep,
              :s_cperson_id=>fee_m_code.dperson,
              :ccode_equal=>fee_m_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #-----------------------------------------------------------------------
        #工作餐费n条借
        if rd_work_meals.count>0
          comb_info={}
          fee_g_code=FeeCodeMatch.find_by_fee_code("0102")
          fcms<<fee_g_code
          rd_work_meals.each do |r|
            #get fee code info
            vd_codes<<fee_g_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_g_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_g_code),
              :s_cdept_id=>fee_g_code.ddep,
              :s_cperson_id=>fee_g_code.dperson,
              :ccode_equal=>fee_g_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #-----------------------------------------------------------------------
        #业务交通费用n条借
        if rd_common_transports.count>0
          comb_info={}
          fee_y_code=FeeCodeMatch.find_by_fee_code("0103")
          fcms<<fee_y_code
          rd_common_transports.each do |r|
            #get fee code info
            vd_codes<<fee_y_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_y_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_y_code),
              :s_cdept_id=>fee_y_code.ddep,
              :s_cperson_id=>fee_y_code.dperson,
              :ccode_equal=>fee_y_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #1条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fcms),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>vd_codes.join(',')})
        self.vouches.create(vd)
      end
    end
  end
  private
  def cdigest_info(fee_code_match)
    cdigest_info=""
    cdigest_info<<"#{person.name},"
    if fee_code_match.is_a? Array
      fee_code_match.each do |fcm|
        cdigest_info<<"#{fcm.fee.name},"
      end
    else
      cdigest_info<<"#{fee_code_match.fee.name}"
    end
    cdigest_info<<"[#{doc_no}]"
    return cdigest_info
  end
  def get_v(options)
    #get current max vouch no and plus 1 as current vouch no
    vouch_no="test in dev"
    if RAILS_ENV=="production"
      vouch_no=U8service::API.max_vouch_info(Time.now.month)["MaxNo"].to_i + 1
    end
    #the time
    time="#{Time.now.year}-#{Time.now.month}-#{Time.now.day}"
    #default options
    #get the default from system config
    config_cbill=SystemConfig.find_by_key("cbill")
    default_opt={
      :ino_id=>"#{vouch_no}",:inid=>"1",:dbill_date=>time,
      :idoc=>"0",:cbill=>(config_cbill ? config_cbill.value : "OES"),:doc_no=>"#{person.name},#{doc_type_name}[#{doc_no}]",
      :ccode=>"",# dai kemu
      :cexch_name=>"人民币",#currency name
      :md=>"0",:mc=>"0",:md_f=>"0",:mc_f=>"0",
      :nfrat=>"1",# currency rate
      :cdept_id=>"00001",# dep code should select
      :person=>person,#person code
      :citem_id=>"",#project code should select
      :ccode_equal=>""}
    default_opt.merge! options
  end

end
