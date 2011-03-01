class Vouch < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :dep
  belongs_to :person
  belongs_to :project,:class_name=>"Project",:foreign_key=>"item_id"
  belongs_to :code,:class_name=>"U8code",:foreign_key=>"code_id"
  belongs_to :code_equal,:class_name=>"U8code",:foreign_key=>"code_equal_id"
  def cdept_id
    dep==nil ? "1010" : dep.code
  end
  def citem_id
    project==nil ? "2180102" : project.code
  end
  def cperson_id
    #贷的时候永远是00001
    if md==0
      return "00001"
    end
    person==nil ? "00001" : person.code
  end
  def ccode
    code==nil ? "" : code.ccode
  end
  def ccode_equal
    code_equal==nil ? "" : code_equal.ccode
  end
  def p_name
    person==nil ? "" : person.name
  end
end
