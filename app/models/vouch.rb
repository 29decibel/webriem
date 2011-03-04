class Vouch < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :dep
  belongs_to :person
  belongs_to :project,:class_name=>"Project",:foreign_key=>"item_id"
  belongs_to :code,:class_name=>"U8code",:foreign_key=>"code_id"
  belongs_to :code_equal,:class_name=>"U8code",:foreign_key=>"code_equal_id"
  #注意s_cdept_id和s_cperson_id为两个强制指定的内容，如果有这个内容则忽略单据上已有的
  def cdept_id
    if s_cdept_id and !s_cdept_id.blank?
      return s_cdept_id
    end
    dep==nil ? "1010" : dep.code
  end
  def citem_id
    project==nil ? "" : project.code
  end
  def cperson_id
    if s_cperson_id and !s_cperson_id.blank?
      return s_cperson_id
    end
    #贷的时候永远是00001
    if md==0
      return "00001"
    end
    person==nil ? "" : person.code
  end
  #只有这一个是引用的方式，对方科目就是简单的字符串
  def ccode
    code==nil ? "" : code.ccode
  end
  def p_name
    person==nil ? "" : person.name
  end
end
