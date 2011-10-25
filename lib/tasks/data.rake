#coding: utf-8
namespace :data do
  desc "init doc row meta infos"
  task :init_doc_meta => :environment do
    # doc row meta info
    DocRowMetaInfo.delete_all
    reciver = DocRowMetaInfo.create :name=>'Reciver',:display_name=>'收款信息',:fi_adapt=>false,:hr_adapt=>false  ,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    borrow = DocRowMetaInfo.create :name=>'BorrowDocDetail',:display_name=>'借款单明细',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    pay = DocRowMetaInfo.create :name=>'PayDocDetail',:display_name=>'付款单明细',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_travel = DocRowMetaInfo.create :name=>'RdTravel',:display_name=>'差旅费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_transport = DocRowMetaInfo.create :name=>'RdTransport',:display_name=>'机车费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_lodging = DocRowMetaInfo.create :name=>'RdLodging',:display_name=>'住宿费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    other = DocRowMetaInfo.create :name=>'OtherRiem',:display_name=>'其他费用',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_commu = DocRowMetaInfo.create :name=>'RdCommunicate',:display_name=>'交际费用',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_extra_car = DocRowMetaInfo.create :name=>'RdExtraWorkCar',:display_name=>'加班车费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_extra_meal = DocRowMetaInfo.create :name=>'RdExtraWorkMeal',:display_name=>'加班餐费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    common = DocRowMetaInfo.create :name=>'CommonRiem',:display_name=>'常用费用',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_work_meal = DocRowMetaInfo.create :name=>'RdWorkMeal',:display_name=>'工作餐费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_common_transport = DocRowMetaInfo.create :name=>'RdCommonTransport',:display_name=>'日常交通费',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'
    rd_beni = DocRowMetaInfo.create :name=>'RdBenefit',:display_name=>'福利费用',:fi_adapt=>false,:hr_adapt=>false,:read_only_attrs => 'apply_amount,hr_amount,fi_amount'



    # doc meta info
    DocMetaInfo.delete_all

    jk = DocMetaInfo.create :name => '借款单',:display_name =>'借款单',:code=>'JK',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note total_amount)
    DocRelation.create :doc_meta_info => jk,:doc_row_meta_info => borrow
    DocRelation.create :doc_meta_info => jk,:doc_row_meta_info => reciver

    cl = DocMetaInfo.create :name => '差旅费',:display_name =>'差旅费报销',:code=>'CL',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id afford_dep_id real_person_id project_id is_split note total_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_travel
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_transport
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_lodging
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => other
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => reciver

    jj = DocMetaInfo.create :name => '交际费用',:display_name =>'交际费用',:code=>'JJ',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note)
    DocRelation.create :doc_meta_info => jj,:doc_row_meta_info => rd_commu
    DocRelation.create :doc_meta_info => jj,:doc_row_meta_info => reciver
    
    pt = DocMetaInfo.create :name => '普通费用',:display_name =>'普通费用',:code=>'PT',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note)
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => rd_work_meal
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => rd_common_transport
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => common
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => reciver
    
    fl = DocMetaInfo.create :name => '包干费用',:display_name =>'福利费用',:code=>'FL',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id is_split note)
    DocRelation.create :doc_meta_info => fl,:doc_row_meta_info => rd_beni
    DocRelation.create :doc_meta_info => fl,:doc_row_meta_info => reciver
  end
end
