#coding: utf-8
class Person < ActiveRecord::Base
  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :boss, :class_name => "Person", :foreign_key => "boss_id"
  belongs_to :role, :class_name => "Role", :foreign_key => "role_id"
  validates_presence_of :duty_id,:name,:code,:phone,:e_mail,:ID_card,:bank_no,:bank
  validates_uniqueness_of :name,:code,:phone,:e_mail,:ID_card,:bank_no
  enum_attr :gender, [['未知',0],['男', 1], ['女', 2]]
  blongs_to_name_attr :dep
  blongs_to_name_attr :duty
  blongs_to_name_attr :role
  blongs_to_name_attr :boss
  #===================================================================================
  CUSTOM_QUERY={
      'dep_id'=>{:include=>:dep,:conditions=>'deps.name like ?'},
      'duty_id'=>{:include=>:duty,:conditions=>'duties.name like ?'},
      'boss_id'=>{:include=>:boss,:conditions=>'bosses_people.name like ?'},
      'role_id'=>{:include=>:role,:conditions=>'roles.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  #===================================================================================
  def to_s
    "#{name};#{code}"
  end
end
