#coding: utf-8
module U8service
  class API
    ProjectsServiceURL="http://203.235.212.65/getAllProjectsInformationFromGPM.do"
    EmployeesServiceURL="http://10.120.108.97:7001/web2011/GetEmployeeInformations.do"
    U8ServiceURL="http://10.120.128.27:8008/Service1.asmx"
    #the database name current
    #UFDATA_500_2011 configured in the system_configs table
    #GenerateAccVouch      
       #<dbname>string</dbname>
       #<csign>string</csign>
       #<isignseq>int</isignseq>
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
      get("GenerateAccVouch",options)
    end
    def self.get_codes
      get("GetCodes")
    end
    def self.get_person
      get("GetPerson")
    end
    def self.get_departments
      get("GetDepartment")
    end
    def self.get_projects
      get("GetProjects")
    end
    def self.get_currency
      get("GetCurrency")
    end
    def self.get(service_name,options={})
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
    def self.get_hr_employees
      response=RestClient.get EmployeesServiceURL
      return response
    end
    def self.get_gpm_projects
      response=RestClient.get ProjectsServiceURL
    end
  end
end
