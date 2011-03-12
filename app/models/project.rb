#coding: utf-8
class Project < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :code
  P_STATUS={0=>"打开状态",1=>"已关闭"}
  def to_s
    "#{code};#{name}"
  end
  def status_name
    return P_STATUS[status] if status
    P_STATUS[0]
  end
  def before_save
    self.code=self.code.strip
    self.name=self.name.strip
  end
end
