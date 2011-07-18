$config = YAML::load(File.open(Rails.root.join('config/u8service.yml')))
class Accvouch < ActiveRecord::Base
  establish_connection $config['mssql']
  set_table_name  :GL_accvouch
  after_initialize  :set_default
  def set_default
    self.csign="记"
    self.isignseq = 1
  end
  # current
  def self.max_no
    Accvouch.where('iperiod=?',Time.now.month).max(:ino_id)
  end
  def self.exist? doc_no
    Accvouch.exists?("cdigest like '%#{doc_no}%'")
  end
  def self.g_vouch doc
    result = true
    doc.vouches.each do |v|
      accv = Account.new
      accv.ino_id = v.ino_id
      accv.inid = v.inid
      accv.dbill_date = Time.now.to_date
      accv.iperiod = Time.now.month
      accv.citem_class = '00'
      accv.idoc = v.idoc
      accv.cbill = v.cbill
      accv.ccode = v.ccode
      accv.cexch_name = v.cexch_name

      accv.md = v.md
      accv.mc = v.mc
      accv.md_f = v.md_f
      accv.mc_f = v.mc_f
      accv.nfrat = v.nfrat

      accv.cdept_id = v.cdept_id
      accv.cperson_id = v.cperson_id
      accv.citem_id = v.citem_id
      accv.ccode_equal = v.ccode_equal

      accv.cdigest = "ExpenseSys:#{doc_no}"
      begin
        result = accv.save and result
      rescue 
        # accv.where('ino_id=? and iperiod=?',v.ino_id,v.dbill_date.month).delete_all
        logger.error "???? Generate vouch error #{doc.doc_no}"
      end
    end
    result
  end
end

