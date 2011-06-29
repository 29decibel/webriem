#coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name,:email, :password, :password_confirmation, :remember_me
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :password_confirmation
  #get the true person
  def person
    Person.find_by_code(self.name)
  end

  def casher?
    return false if !person
    sc = SystemConfig.find_by_key('casher_duty_code')
    if sc and sc.value and person.duty
      person.duty.code == sc.value
    else
      false
    end
  end
end
