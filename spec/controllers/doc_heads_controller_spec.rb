#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )
describe  DocHeadsController do
  describe "print docs" do
    it "borrow_doc_details should be ok" do
      doc = Factory(:doc_head)
      Factory(:borrow_doc_detail,:ori_amount=>23,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "pay_doc_details should be ok" do
      doc = Factory(:doc_head)
      Factory(:pay_doc_detail,:ori_amount=>23,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "差旅费报销单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>9)
      Factory(:rd_travel,:doc_head=>doc)
      Factory(:rd_transport,:doc_head=>doc)
      Factory(:rd_lodging,:doc_head=>doc)
      Factory(:other_riem,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "交际报销单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>10)
      Factory(:rd_communicate,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "加班销单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>11)
      Factory(:rd_extra_work_meal,:doc_head=>doc)
      Factory(:rd_extra_work_car,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "普通费用的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>12)
      Factory(:common_riem,:doc_head=>doc)
      Factory(:rd_work_meal,:doc_head=>doc)
      Factory(:rd_common_transport,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    it "福利费用的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>13)
      Factory(:rd_benefit,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
    end

    def assign_others doc
      Factory(:reciver,:amount=>23,:doc_head=>doc)
      Factory(:work_flow_info,:doc_head=>doc)
    end
  end
end
