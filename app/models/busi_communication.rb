#coding: utf-8
class BusiCommunication < ActiveRecord::Base
  has_paper_trail
  belongs_to :vrv_project
  
  WAY = %w(送达资料 电话沟通 商务会谈 约定下次交流)
  FEEDBACK = %w(有难度 有进入下一步意向 我们有机会 非常满意)
  validates :way,:inclusion => WAY
  validates :feedback,:inclusion => FEEDBACK
  validates_presence_of :date,:person,:duty,:phone,:way,:feedback
end
