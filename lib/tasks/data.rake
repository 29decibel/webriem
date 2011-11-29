#coding: utf-8
namespace :data do
  desc "init doc row meta infos"
  task :init_doc_meta => :environment do
    # doc row meta info
    DocRowMetaInfo.delete_all
    borrow = DocRowMetaInfo.create :name=>'BorrowDocDetail',:display_name=>'借款单明细',:read_only_attrs => 'apply_amount'
    pay = DocRowMetaInfo.create :name=>'PayDocDetail',:display_name=>'付款单明细',:read_only_attrs => 'apply_amount'
    rd_travel = DocRowMetaInfo.create :name=>'RdTravel',:display_name=>'差旅费',:read_only_attrs => 'apply_amount'
    rd_transport = DocRowMetaInfo.create :name=>'RdTransport',:display_name=>'机车费',:read_only_attrs => 'apply_amount'
    rd_lodging = DocRowMetaInfo.create :name=>'RdLodging',:display_name=>'住宿费',:read_only_attrs => 'apply_amount'
    other = DocRowMetaInfo.create :name=>'OtherRiem',:display_name=>'其他费用',:read_only_attrs => 'apply_amount'
    rd_commu = DocRowMetaInfo.create :name=>'RdCommunicate',:display_name=>'交际费用',:read_only_attrs => 'apply_amount'
    rd_extra_car = DocRowMetaInfo.create :name=>'RdExtraWorkCar',:display_name=>'加班车费',:read_only_attrs => 'apply_amount'
    rd_extra_meal = DocRowMetaInfo.create :name=>'RdExtraWorkMeal',:display_name=>'加班餐费',:read_only_attrs => 'apply_amount'
    common = DocRowMetaInfo.create :name=>'CommonRiem',:display_name=>'常用费用',:read_only_attrs => 'apply_amount'
    rd_work_meal = DocRowMetaInfo.create :name=>'RdWorkMeal',:display_name=>'工作餐费',:read_only_attrs => 'apply_amount'
    rd_common_transport = DocRowMetaInfo.create :name=>'RdCommonTransport',:display_name=>'日常交通费',:read_only_attrs => 'apply_amount'
    rd_beni = DocRowMetaInfo.create :name=>'RdBenefit',:display_name=>'福利费用',:read_only_attrs => 'apply_amount'
    rd_split = DocRowMetaInfo.create :name=>'ReimSplitDetail',:display_name=>'费用分摊明细',:read_only_attrs => 'apply_amount'


    # doc meta info
    DocMetaInfo.delete_all

    jk = DocMetaInfo.create :name => '借款单',:display_name =>'借款单',:code=>'JK',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note total_amount)
    DocRelation.create :doc_meta_info => jk,:doc_row_meta_info => borrow,:doc_row_attrs=>%w(project_id fee_id used_for currency_id rate ori_amount apply_amount)

    cl = DocMetaInfo.create :name => '差旅费',:display_name =>'差旅费报销',:code=>'CL',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id afford_dep_id real_person_id project_id note total_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_travel,:doc_row_attrs=>%w(days region_type_id region_id custom_place reason reason_type st_amount currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_transport,:doc_row_attrs=>%w(start_date end_date start_position end_position reason transportation_id currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_lodging,:doc_row_attrs=>%w(start_date end_date days region_type_id region_id custom_place people_count person_names st_amount currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => other,:doc_row_attrs=>%w(description currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => cl,:doc_row_meta_info => rd_split,:doc_row_attrs=>%w(dep_id project_id percent_amount)

    jj = DocMetaInfo.create :name => '交际费用',:display_name =>'交际费用',:code=>'JJ',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note)
    DocRelation.create :doc_meta_info => jj,:doc_row_meta_info => rd_commu,:doc_row_attrs=>%w(project_id place meal_date people_count person_names reason currency_id rate ori_amount apply_amount)
    
    pt = DocMetaInfo.create :name => '普通费用',:display_name =>'普通费用',:code=>'PT',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note)
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => rd_work_meal,:doc_row_attrs=>%w(project_id place meal_date people_count person_names reason currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => rd_common_transport,:doc_row_attrs=>%w(project_id start_place end_place start_time end_time reason currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => pt,:doc_row_meta_info => common,:doc_row_attrs=>%w(project_id fee_id description currency_id rate ori_amount apply_amount)
    
    fl = DocMetaInfo.create :name => '包干费用',:display_name =>'福利费用',:code=>'FL',:doc_head_attrs =>%w(doc_no person_id apply_date attach dep_id real_person_id note)
    DocRelation.create :doc_meta_info => fl,:doc_row_meta_info => rd_beni,:doc_row_attrs=>%w(project_id fee_id people_count reim_date currency_id rate ori_amount apply_amount)
    DocRelation.create :doc_meta_info => fl,:doc_row_meta_info => rd_split,:doc_row_attrs=>%w(dep_id project_id percent_amount)
  end

  desc "clear data"
  task :clear => :environment do
    models = %w(DocHead DocRow VrvProject ApproverInfo WorkFlowInfo) + DocRowMetaInfo.all.map(&:name)
    models.each {|m|eval(m).delete_all}
  end
end
