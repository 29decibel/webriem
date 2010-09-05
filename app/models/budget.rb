#coding: utf-8
class Budget < ActiveRecord::Base
    belongs_to :fee
    belongs_to :project
    belongs_to :dep
    def fee_name
       if self.fee==nil
         ""
       else
         self.fee.name
       end
    end
    def project_name
       if self.project==nil
          ""
       else
         self.project.name
       end
    end
    def dep_name
       if self.dep==nil
         ""
       else
         self.dep.name
       end
    end
    def all
      jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec
    end
end
