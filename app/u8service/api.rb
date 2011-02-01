module U8service
  class API
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
    #GetCurrency          
       #<dbname>string</dbname>
    #GetDepartment
       #<dbname>string</dbname>
    #GetPerson
       #<dbname>string</dbname>
    #GetProjects
       #<dbname>string</dbname>
       #<project_table_name>string</project_table_name>
    #GetCodes
       #<dbname>string</dbname>
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
      _username =options[:username] || username
      _password =options[:password] || password
      para={:dbname=>_dbname,:username=>_username,:password=>_password}
      #para=para.merge options.except()
      response = RestClient.post "#{U8ServiceURL}/#{service_name}", para.to_json, :content_type => :json, :accept => :json
      return JSON(response.body)["d"]
    end
    #here is the config info of current year's info
    def self.dbname
      config=U8serviceConfig.find_by_year(Time.now.year)
      config==nil ? nil : config.dbname
    end
    def self.username
      config=U8serviceConfig.find_by_year(Time.now.year)
      config==nil ? nil : config.username
    end
    def self.password
      config=U8serviceConfig.find_by_year(Time.now.year)
      config==nil ? nil : config.password
    end
  end
end
