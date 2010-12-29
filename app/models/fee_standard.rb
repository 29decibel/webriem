#coding: utf-8
class FeeStandard < ActiveRecord::Base
  belongs_to :project
  belongs_to :region_type
  belongs_to :duty
  belongs_to :lodging
  belongs_to :transportation
  belongs_to :business_type
  belongs_to :currency
  belongs_to :fee
  belongs_to :person_type
  blongs_to_name_attr :business_type
  blongs_to_name_attr :project
  blongs_to_name_attr :region_type
  blongs_to_name_attr :duty
  blongs_to_name_attr :lodging
  blongs_to_name_attr :transportation
  blongs_to_name_attr :currency
  blongs_to_name_attr :fee
  blongs_to_name_attr :person_type
  validates_presence_of :fee_id
  netzke_exclude_attributes :created_at, :updated_at
  #enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  #===================================================================================
  CUSTOM_QUERY={
      'project_id'=>{:include=>:project,:conditions=>'projects.name like ?'},
      'region_type_id'=>{:include=>:region_type,:conditions=>'region_types.name like ?'},
      'duty_id'=>{:include=>:duty,:conditions=>'duties.name like ?'},
      'lodging_id'=>{:include=>:lodging,:conditions=>'lodgings.name like ?'},
      'transportation_id'=>{:include=>:transportation,:conditions=>'transportations.name like ?'},
      'business_type_id'=>{:include=>:business_type,:conditions=>'business_types.name like ?'},
      'currency_id'=>{:include=>:currency,:conditions=>'currencies.name like ?'},
      'fee_id'=>{:include=>:fee,:conditions=>'fees.name like ?'},
      'person_type_id'=>{:include=>:person_type,:conditions=>'person_types.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  def to_s
    "#{name}"
  end
end
