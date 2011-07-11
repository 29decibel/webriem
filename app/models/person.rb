#coding: utf-8
class Person < ActiveRecord::Base
  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :role, :class_name => "Role", :foreign_key => "role_id"
  belongs_to :person_type, :class_name => "PersonType", :foreign_key => "person_type_id"
  validates_presence_of :duty_id,:name,:code,:e_mail,:ID_card,:bank_no,:bank
  validates_uniqueness_of :name,:code,:e_mail,:ID_card,:bank_no
  enum_attr :gender, [["未知",0],["男", 1], ["女", 2]]
  blongs_to_name_attr :dep
  blongs_to_name_attr :duty
  blongs_to_name_attr :role
  blongs_to_name_attr :person_type
  after_save :ensure_user
  #===================================================================================
  def self.not_display
    ['end_date','credit_limit','ID_card','bank_no','role_id']
  end
  def self.not_search
    []
  end
  CUSTOM_QUERY={
      'dep_id'=>{:include=>:dep,:conditions=>'deps.name like ?'},
      'duty_id'=>{:include=>:duty,:conditions=>'duties.name like ?'},
      'role_id'=>{:include=>:role,:conditions=>'roles.name like ?'},
      'person_type_id'=>{:include=>:person_type,:conditions=>'person_types.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  def custom_display(column)
    column_name=column.class==String ? column:column.name
    if column_name=="gender"
      return (Person::ENUMS_GENDER.select {|g| g[1]==gender}).first[0]
    end
  end
  def self.custom_select(results,column_name,filter_text)
  	if column_name=="gender"
    	results.select {|person| person.custom_display.include? filter_text}
	  else
		  results
	  end
  end
  #===================================================================================
  def to_s
    "#{name}"
  end
  private
  def ensure_user
    u = User.find_by_name self.code
    if !u
      old_u = User.find_by_email self.e_mail
      if old_u
        old_u.update_attribute :name,self.code
      end
    end
  end
end
