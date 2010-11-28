#coding: utf-8
class WorkFlowStep < ActiveRecord::Base
  belongs_to :work_flow
  belongs_to :dep
  belongs_to :duty
  enum_attr :is_self_dep, [["#{I18n.t('common_attr.__ok')}", 0], ["#{I18n.t('common_attr.sure_not')}", 1]]
end
