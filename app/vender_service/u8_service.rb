#coding: utf-8
class U8Service
  #def self.test_g_vouch
  #  options={
  #    :ino_id=>"10000",:inid=>"4444",:dbill_date=>"2011-3-1",
  #    :idoc=>"999",:cbill=>"mike",:doc_no=>"8989898989",
  #    :ccode=>"55011001",# dai kemu
  #    :cexch_name=>"rmb",#currency name
  #    :md=>"121212",:mc=>"0",:md_f=>"121212",:mc_f=>"0",
  #    :nfrat=>"1",# currency rate
  #    :cdept_id=>"100901",# dep code
  #    :cperson_id=>"CS10011",#person code
  #    :citem_id=>"OTH-99",#project code
  #    :ccode_equal=>""}
  #  generate_vouch(options)
  #end
  def self.generate_vouch_from_doc(vmodel)
    insert_cmd = "insert into GL_accvouch (iperiod,csign,isignseq,ino_id,inid,dbill_date,idoc,cbill,cdigest,ccode,cexch_name,md,mc, md_f, mc_f, nfrat,cdept_id,cperson_id,citem_id, citem_class, ccode_equal,iyear,iYPeriod) 
            values('#{Time.now.month}',N'记','1','#{vmodel.ino_id}','#{vmodel.inid}','#{Time.now.to_date}','#{vmodel.idoc}',N'#{vmodel.cbill}',N'OES_V0.1:#{vmodel.doc_no}','#{vmodel.ccode}',N'#{vmodel.cexch_name}',#{vmodel.md},#{vmodel.mc},#{vmodel.md_f},#{vmodel.mc_f},#{vmodel.nfrat},'#{vmodel.cdept_id}',#{vmodel.cperson_id.blank? ? 'null' : "'#{vmodel.cperson_id}'"},'#{vmodel.citem_id}','#{vmodel.citem_class}','#{vmodel.ccode_equal}','#{Time.now.year}','#{Time.now.strftime('%Y%m')}')"
    puts '## begin insert into u8 database of vouch .....'
    puts "## #{insert_cmd}"
    result_msg = ''
    begin 
      result_msg = exec_sql(insert_cmd).to_s
    rescue Exception => error
      puts "!! error when insert #{error}"
      puts "begin delete all vouches of current doc #{vmodel.doc_no}"
      delete_result = self.remove_vouch(vmodel.doc_no)
      puts "delete result is #{delete_result}"
      result_msg = error
    end
    result_msg
  end

  def self.exec_sql(sql)
    client = TinyTds::Client.new(:host=>config('u8_host'),:database=>config('u8_database'),:username=>config('u8_username'),:password=>config('u8_password'),:encoding=>'GBK')
    if sql.start_with? 'select'
      client.execute(sql.encode('GBK')).each
    else
      client.execute(sql.encode('GBK')).do
    end
  end

  def self.config(name)
    @cached_config = {}
    @cached_config[name] ||=SystemConfig.value(name)
  end

  def self.remove_vouch doc_no
    # make sure the doc_no is valid
    if doc_no.length > 8
      delete_cmd = "delete gl_accvouch where cdigest like '%#{doc_no}%'"
      self.exec_sql delete_cmd
    else
      "doc no is not valid, please check if it ok"
    end
  end

  def self.exist_vouch(doc_no)
    return false if !Rails.env.production?
    select_cmd = "select count(*) from gl_accvouch where cdigest like '%#{doc_no}%'"
    self.exec_sql(select_cmd).first[""] > 0
  end
  def self.max_ino_id
    return 123456788 if Rails.env.development?
    select_cmd = "select max(ino_id) from GL_accvouch where iperiod='#{Time.now.month}'"
    self.exec_sql(select_cmd).first[""]
  end


end
