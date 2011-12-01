#coding: utf-8
class Vouch < ActiveRecord::Base
  belongs_to :doc_head

  belongs_to :dep
  belongs_to :person
  belongs_to :project,:class_name=>"Project",:foreign_key=>"item_id"
  belongs_to :r_ccode,:class_name=>'U8code',:foreign_key=>"r_ccode_id"
  belongs_to :r_ccode_equal,:class_name=>'U8code',:foreign_key=>"r_ccode_equal_id"
  before_create :set_attributes

  scope :jie, where('md > 0')
  scope :dai, where('mc > 0')
  #注意s_cdept_id和s_cperson_id为两个强制指定的内容，如果有这个内容则忽略单据上已有的

  def citem_valid?(citem)
    sql = "select count(*) as count from fitemss00 where citemcode='#{citem}'"
    U8Vouch.exec_sql(sql)[0]['count'] > 0
  end

  def send_to_u8(ino_id,inid)
    table = 'GL_accvouch'
    conditions = {
      :iperiod=>Time.now.month,
      :csign=>'记',##
      :isignseq=>1,
      :ino_id=>ino_id,##当月最大
      :inid=>inid,##自增 1
      :dbill_date=>dbill_date,
      :idoc=>'0',##可以修改
      :cbill=>self.cbill,
      :cdigest=>self.cdigest,
      :ccode=>ccode,##借方科目
      :ccode_equal=>ccode_equal,##
      :cexch_name=>'人民币',
      :md=>md||0,##借
      :mc=>mc||0, ##
      :md_f=>md_f||0,## 
      :mc_f=>mc_f||0, ##
      :nfrat=>self.nfrat,
      :cdept_id=>cdept_id,##
      :cperson_id=>cperson_id,##
      :citem_id=>citem_id, ##
      :citem_class=>'00',## 项目
      :iyear=>Time.now.year,
      :iYPeriod=>Time.now.strftime('%Y%m') 
    }
    sql = "insert #{table}#{conditions_sql(conditions)}"
    begin 
      U8Service.exec_sql(sql).to_s
    rescue Exception => error
      puts "!! error when insert #{error}"
      puts "begin delete all vouches of current doc #{doc_no}"
      delete_result = remove_vouch(doc_no)
      puts "delete result is #{delete_result}"
      error
    end
  end

  def conditions_sql(conditions)
    cols = []
    values = []
    conditions.each_pair do |k,v|
      cols << k.to_s
      if v
        values << (v.is_a?(Array) ? v.first : "'#{v.to_s}'")
      else
        values << 'null'
      end
    end
    "(#{cols.join(',')}) values(#{values.join(',')})"
  end

  def remove_vouch doc_no
    # make sure the doc_no is valid
    if doc_no.length > 8
      delete_cmd = "delete gl_accvouch where cdigest like '%#{doc_no}%'"
      U8Service.exec_sql delete_cmd
    else
      "doc no is not valid, please check if it ok"
    end
  end

  # 科目，人员，部门，项目，一样就合并
  # 费用求总，对方科目compact and join
  def merge
    
  end

  private
  def set_attributes
    # 根据费用类型找出借方科目
    if r_ccode
      puts 'have fee and fee.ccode'
      if r_ccode.bdept
        puts 'set dept'
        self.cdept_id = dep.code
      end
      if r_ccode.bitem
        puts 'set bitem'
        self.citem_id = project.code
      end
    end
    self.ccode_equal = r_ccode_equal.ccode
    self.ccode = r_ccode.ccode
    self.cperson_id = person.code
    self.dbill_date = Time.now
    self.cbill = SystemConfig.value('cbill') || "OES"
    self.cdigest = "OES,#{self.doc_head.doc_no}"
    self.nfrat = '1'
  end
end
