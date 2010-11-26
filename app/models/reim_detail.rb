#coding: utf-8
class ReimDetail < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  #here is the details
  has_many :rd_travels, :class_name => "RdTravel", :foreign_key => "reim_detail_id"
  has_many :rd_transports, :class_name => "RdTransport", :foreign_key => "reim_detail_id"
  has_many :rd_lodgings, :class_name => "RdLodging", :foreign_key => "reim_detail_id"
  has_many :rd_work_meals, :class_name => "RdWorkMeal", :foreign_key => "reim_detail_id"
  has_many :rd_extra_work_cars, :class_name => "RdExtraWorkCar", :foreign_key => "reim_detail_id"
  has_many :rd_extra_work_meals, :class_name => "RdExtraWorkMeal", :foreign_key => "reim_detail_id"
  has_many :rd_benefits, :class_name => "RdBenefit", :foreign_key => "reim_detail_id"
  has_many :rd_common_transports, :class_name => "RdCommonTransport", :foreign_key => "reim_detail_id"
  has_many :reim_split_details, :class_name => "ReimSplitDetail", :foreign_key => "reim_detail_id"
  accepts_nested_attributes_for :reim_split_details ,:reject_if => lambda { |a| a[:dep_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_travels ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  enum_attr :is_split, [["#{I18n.t('common_attr.not')}", 0], ["#{I18n.t('common_attr.ok')}", 1]]
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"部门必须为末级部门") if dep and dep.sub_deps.count>0
  end
end
