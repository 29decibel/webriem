#coding: utf-8
class Project < ActiveRecord::Base

  validates_presence_of :name,:code
  validates_uniqueness_of :code

  belongs_to :dep

  before_save :strip

  def to_s
    "#{code};#{name}"
  end

  def status_enum
    ["打开状态","已关闭"]
  end

  def strip
    self.code=self.code.strip
    self.name=self.name.strip
  end
end
