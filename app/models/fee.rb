#coding: utf-8
class Fee < ActiveRecord::Base
  belongs_to :parent_fee, :class_name => "Fee", :foreign_key => "parent_fee_id"
  has_many :fees, :class_name => "Fee", :foreign_key => "parent_fee_id"
  belongs_to :ccode,:class_name=>"U8code",:foreign_key=>"ccode_id"

  scope :system,where("fee_type is not null")

  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  def to_s
    "#{name}[#{code}]"
  end

end
