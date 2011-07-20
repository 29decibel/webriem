#coding: utf-8
module U8service
  class API
    ProjectsServiceURL="http://gpm.skcc.com/getAllProjectsInformationFromGPM.do"
    EmployeesServiceURL="http://10.120.108.97:7001/web2011/GetEmployeeInformations.do"
    U8ServiceURL="http://10.120.128.28:8008/Service1.asmx"
    #the database name current
    #UFDATA_500_2011 configured in the system_configs table
    #GenerateAccVouch      
       #<dbname>string</dbname>
       #<ino_id>short</ino_id>
       #<inid>short</inid>
       #<dbill_date>string</dbill_date>
       #<idoc>short</idoc>
       #<cbill>string</cbill>
       #<cdigest>string</cdigest>
       #<ccode>string</ccode>
       #<cexch_name>string</cexch_name>
       #<md>decimal</md>
       #<mc>decimal</mc>
       #<md_f>decimal</md_f>
       #<mc_f>decimal</mc_f>
       #<nfrat>double</nfrat>
       #<cdept_id>string</cdept_id>
       #<cperson_id>string</cperson_id>
       #<citem_id>string</citem_id>
       #<citem_class>string</citem_class>
       #<ccode_equal>string</ccode_equal> 
    def self.generate_vouch(options)
      JSON get("GenerateAccVouch",options)
    end
    def self.test_g_vouch
      options={
        :ino_id=>"10000",:inid=>"4444",:dbill_date=>"2011-3-1",
        :idoc=>"999",:cbill=>"mike",:doc_no=>"8989898989",
        :ccode=>"55011001",# dai kemu
        :cexch_name=>"rmb",#currency name
        :md=>"121212",:mc=>"0",:md_f=>"121212",:mc_f=>"0",
        :nfrat=>"1",# currency rate
        :cdept_id=>"100901",# dep code
        :cperson_id=>"CS10011",#person code
        :citem_id=>"OTH-99",#project code
        :ccode_equal=>""}
      generate_vouch(options)
    end
    def self.generate_vouch_from_doc(vmodel)
      insert_cmd = "insert into GL_accvouch (iperiod,csign,isignseq,ino_id,inid,dbill_date,idoc,cbill,cdigest,ccode,cexch_name,md,mc, md_f, mc_f, nfrat,cdept_id,cperson_id,citem_id, citem_class, ccode_equal,iyear,iYPeriod) 
              values('#{Time.now.month}',N'记','1','#{vmodel.ino_id}','#{vmodel.inid}','#{Time.now.to_date}','#{vmodel.idoc}',N'#{vmodel.cbill}',N'OES_V0.1:#{vmodel.doc_no}','#{vmodel.ccode}',N'#{vmodel.cexch_name}',#{vmodel.md},#{vmodel.mc},#{vmodel.md_f},#{vmodel.mc_f},#{vmodel.nfrat},'#{vmodel.cdept_id}',#{vmodel.cperson_id.blank? ? 'null' : "'#{vmodel.cperson_id}'"},'#{vmodel.citem_id}','00','#{vmodel.ccode_equal}','#{Time.now.year}','#{Time.now.strftime('%Y%m')}')"
      puts '## begin insert into u8 database of vouch .....'
      puts "## #{insert_cmd}"
      result_msg = ''
      begin 
        result_msg = exec_sql(insert_cmd).to_s
      rescue Exception => error
        puts "!! error when insert #{error}"
        result_msg = error
      end
      result_msg
    end

    def self.exec_sql(sql)
      client = TinyTds::Client.new(:host=>'10.120.128.28',:database=>'UFDATA_500_2011',:username=>'sa',:password=>'',:encoding=>'GBK')
      client.execute(sql.encode('GBK')).do
    end

    def self.remove_vouch doc_no
      delete_cmd = "delete gl_accvouch where cdigest like '%#{doc_no}%'"
      self.exec_sql delete_cmd
    end

    def self.exist_vouch(doc_no)
      JSON get("IsVouchExist",{:doc_no=>doc_no})
    end
    def self.max_vouch_info(iperiod)
      JSON get("GetMaxVouchInfo",{:iperiod=>iperiod})
    end
    def self.get_codes
      JSON get("GetCodes")
    end
    def self.get_person
      JSON get("GetPerson")
    end
    def self.get_departments
      JSON get("GetDepartment")
    end
    def self.get_projects
      JSON get("GetProjects")
    end
    def self.get_currency
      JSON get("GetCurrency")
    end
    def self.get(service_name,options={})
      if RAILS_ENV=="development"
        return "{}"
      end
      _dbname =options[:dbname] || dbname
      para={:dbname=>_dbname}
      para.merge! options.except(:dbname)
      #para=para.merge options.except()
      response = RestClient.post "#{U8ServiceURL}/#{service_name}", para.to_json, :content_type => :json, :accept => :json
      return JSON(response.body)["d"]
    end
    #here is the config info of current year's info
    def self.dbname
      config=SystemConfig.find_by_key("u8dbname")
      if config and config.value
        return config.value
      end
      Rails.logger.error("请配置u8数据库的名称")
      ""
    end
    #<name>高波</name>
    #<empno>CS10065</empno>
    #<gender>女</gender>
    #<deptid>100103</deptid>
    #deptName
    #<mobile>131-2049-7186</mobile>
    #<email>gaobo@skccsystems.cn</email>
    #idCard
    #bankid
    def self.get_hr_employees
      emps=[]
      begin
        response=RestClient.get EmployeesServiceURL
        xml_doc=REXML::Document.new response.to_s
        xml_doc.root.elements.each do |ele|
          p=Person.new
          p.name=ele.elements["name"].text.strip if ele.elements["name"]
          p.code=ele.elements["empno"].text.strip if ele.elements["empno"]
          p.gender=ele.elements["gender"].text=="男" ? 1 : 0 if ele.elements["gender"]
          p.dep_id=ele.elements["deptid"].text.strip if ele.elements["deptid"]
          p.phone=ele.elements["mobile"].text.strip if ele.elements["mobile"]
          p.e_mail=ele.elements["email"].text.strip if ele.elements["email"]
          p.bank_no=ele.elements["bankid"].text.strip if ele.elements["bankid"]
          p.ID_card=ele.elements["idCard"].text.strip if ele.elements["idCard"]
          emps<<p
        end
      rescue Exception=>msg
        Rails.logger.error "can't get the employees info from hr system,errors is #{msg}"
      end
      return emps
    end
    def self.get_gpm_projects
      projects=[]
      begin
        response=RestClient.get ProjectsServiceURL
        xml_doc=REXML::Document.new response.to_s
        xml_doc.root.elements.each do |ele|
          p=Project.new
          p.name=ele.elements["prjName"].text.strip
          p.code=ele.elements["prjId"].text.strip
          p.status=1
          projects<<p
        end
      rescue Exception=>msg
        Rails.logger.error "can't get the projects from gpm,errors is #{msg}"
      end
      return projects
    end
  end
end
