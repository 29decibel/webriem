class Vouch < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :dep
  belongs_to :person
  belongs_to :project,:class_name=>"Project",:foreign_key=>"item_id"
  belongs_to :code,:class_name=>"U8code",:foreign_key=>"code_id"
  belongs_to :code_equal,:class_name=>"U8code",:foreign_key=>"code_equal_id"
  def cdep_id
    dep==nil ? "" : dep.code
  end
  def citem_id
    project==nil ? "" : project.code
  end
  def cperson_id
    person==nil ? "" : person.code
  end
  def ccode
    code==nil ? "" : code.ccode
  end
  def ccode_equal
    code_equal==nil ? "" : code_equal.ccode
  end
end
