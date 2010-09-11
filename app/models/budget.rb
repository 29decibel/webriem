#coding: utf-8
class Budget < ActiveRecord::Base
    belongs_to :fee
    belongs_to :project
    belongs_to :dep
    blongs_to_name_attr :fee
    blongs_to_name_attr :project
    blongs_to_name_attr :dep
    validates_presence_of :fee,:project,:dep
    def all
      jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec
    end
end
