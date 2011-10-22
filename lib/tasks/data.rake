#coding: utf-8
namespace :data do
  desc "init doc row meta infos"
  task :init_doc_meta => :environment do
    DocRowMetaInfo.create :name=>'BorrowDocDetail',:display_name=>'借款单明细',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'PayDocDetail',:display_name=>'付款单明细',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdTravel',:display_name=>'差旅费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdTransport',:display_name=>'交通费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdLodging',:display_name=>'住宿费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'OtherRiem',:display_name=>'其他费用',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdCommunicate',:display_name=>'交际费用',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdExtraWorkCar',:display_name=>'加班车费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdExtraWorkMeal',:display_name=>'加班餐费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'CommonRiem',:display_name=>'常用费用',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdWorkMeal',:display_name=>'工作餐费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdCommonTransport',:display_name=>'日常交通费',:fi_adapt=>false,:hr_adapt=>false
    DocRowMetaInfo.create :name=>'RdBenefit',:display_name=>'福利费用',:fi_adapt=>false,:hr_adapt=>false
  end
end
