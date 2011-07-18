#coding: utf-8
$config = YAML::load(File.open(Rails.root.join('config/u8service.yml'))).symbolize
module U8service
  class API
    ProjectsServiceURL="http://gpm.skcc.com/getAllProjectsInformationFromGPM.do"
    EmployeesServiceURL="http://10.120.108.97:7001/web2011/GetEmployeeInformations.do"
    U8ServiceURL="http://10.120.128.28:8008/Service1.asmx"

    def self.generate_vouch_from_doc(vmodel)
      insert_cmd = "insert into GL_accvouch( iperiod,  csign,  isignseq,
                    ino_id,  inid,  dbill_date,  idoc,cbill,  cdigest,  ccode,  cexch_name,
                    md, mc,  md_f, mc_f,  nfrat,  cdept_id,cperson_id,  citem_id,  citem_class, ccode_equal) 
                    values('#{Time.now.month}','#{记}','1',
                    '#{vmodel.ino_id}','#{vmodel.inid}','#{Time.now.to_date}','#{vmodel.idoc}','#{vmodel.cbill}','ExpenseSys:#{vmodel.doc_no}','#{vmodel.ccode}','#{vmodel.cexch_name}',
                    #{vmodel.md},#{vmodel.mc},#{vmodel.md_f},#{vmodel.mc_f},#{vmodel.nfrat},'#{vmodel.cdept_id}',#{vmodel.cperson_id},'#{vmodel.citem_id}','00','#{vmodel.ccode_equal}')"
      result = exe_sql(insert_cmd)
      generate_vouch(options)["Result"]
    end

    def self.exist_vouch(doc_no)
      result = client.execute "select count(*) from [gl_accvouch] where cdigest like '%#{doc_no}%'"
      result.first['']>0
    end

    def self.max_vouch_info(iperiod)
      result = exec_sql 'select max(ino_id) from [gl_accvouch]'
      result.first['']
    end

    def self.get_codes
      exec_sql('select * from [code] ').each
    end

    def self.get_person
      exec_sql('select * from [person] ').each
    end

    def self.get_departments
      exec_sql('select * from [Department] ').each
    end

    def self.get_projects
      exec_sql('select * from [fitemss00] ').each
    end

    def self.get_currency
      exec_sql('select * from [foreigncurrency] ').each
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

    def self.exec_sql(sql)
      client = TinyTds::Client.new($config[:mssql])
      client.execute(sql).each
    end
    #here is the config info of current year's info

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
