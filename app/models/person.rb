#coding: utf-8
class Person < ActiveRecord::Base

  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :role, :class_name => "Role", :foreign_key => "role_id"
  belongs_to :person_type, :class_name => "PersonType", :foreign_key => "person_type_id"

  validates_presence_of :duty_id,:name,:code,:phone,:e_mail,:ID_card,:bank_no,:bank
  validates_uniqueness_of :name,:code,:e_mail

  after_save :update_user
  after_destroy :delete_user

  def to_s
    "#{name}"
  end

  def gender_enum
    ['男','女']
  end

  # if there is no user of current person
  # then create one with person's code
  def update_user
    u = User.find_by_name self.code
    if !u
      User.create :name=>self.code,:email=>self.e_mail,
        :password=>'123456',:password_confirmation=>'123456'
    else
      u.update_attribute :email,self.e_mail
    end
  end

  def casher?
    sc = SystemConfig.find_by_key 'casher_duty_code'
    return false if !sc
    self.duty.code == sc.value
  end

  def delete_user
    u = User.find_by_name :self.code
    u.destroy if u
  end

end
