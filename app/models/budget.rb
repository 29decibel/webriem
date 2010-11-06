#coding: utf-8
class Budget < ActiveRecord::Base
    belongs_to :fee
    belongs_to :project
    belongs_to :dep
    blongs_to_name_attr :fee
    blongs_to_name_attr :project
    blongs_to_name_attr :dep
    validates_presence_of :fee,:project,:dep
    validates_numericality_of :jan,:feb,:mar,:apr,:may,:jun,:jul,:aug,:sep,:oct,:nov,:dec
    def to_s
      "#{name}"
    end
    def all
      jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec
    end
    #===================================================================================
    CUSTOM_QUERY={
        'fee_id'=>{:include=>:fee,:conditions=>'fees.name like ?'},
        'project_id'=>{:include=>:project,:conditions=>'projects.name like ?'},
        'dep_id'=>{:include=>:dep,:conditions=>'deps.name like ?'},
    }
    def self.custom_query(column_name,filter_text)
      if CUSTOM_QUERY.has_key? column_name
        CUSTOM_QUERY[column_name]
      else
        nil
      end
    end
    #===================================================================================
end
