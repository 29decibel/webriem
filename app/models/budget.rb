#coding: utf-8
class Budget < ActiveRecord::Base
    belongs_to :fee
    belongs_to :project
    belongs_to :dep
    blongs_to_name_attr :fee
    blongs_to_name_attr :project
    blongs_to_name_attr :dep
    validates_presence_of :fee,:project,:dep,:year
    validates_numericality_of :jan,:feb,:mar,:apr,:may,:jun,:jul,:aug,:sep,:oct,:nov,:dec
    NumberHash={1=>:jan,2=>:feb,3=>:mar,4=>:apr,5=>:may,6=>:jun,7=>:jul,8=>:aug,9=>:sep,10=>:oct,11=>:nov,12=>:dec}
    def to_s
      "#{name}"
    end
    def all
      jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec
    end
    def by_month(month)
      month_num=month.to_i
      self.send(NumberHash[month_num])
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
    #here is the doc to retrive the fee standard
    scope :project_of, proc {|project_id| where(:project_id=>project_id)}
    scope :dep_of,     proc {|dep_id| where(:dep_id=>dep_id)}
    scope :fee_of,     proc {|fee_id| where(:fee_id=>fee_id)}    
end
