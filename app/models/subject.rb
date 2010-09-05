#coding: utf-8
class Subject < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  def fee_name
     if self.fee==nil
       ""
     else
       self.fee.name
     end
  end
  def dep_name
     if self.dep==nil
       ""
     else
       self.dep.name
     end
  end
end
