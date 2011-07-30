#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )
describe  DocHeadsController do
  describe "print docs" do
    it "借款单打印功能 should be ok" do
      doc = Factory(:doc_head)
      Factory(:borrow_doc_detail,:ori_amount=>23,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "付款单打印功能 should be ok" do
      doc = Factory(:doc_head)
      Factory(:pay_doc_detail,:ori_amount=>23,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
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
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "交际报销单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>10)
      Factory(:rd_communicate,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "加班销单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>11)
      Factory(:rd_extra_work_meal,:doc_head=>doc)
      Factory(:rd_extra_work_car,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "普通费用的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>12)
      Factory(:common_riem,:doc_head=>doc)
      Factory(:rd_work_meal,:doc_head=>doc)
      Factory(:rd_common_transport,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "福利费用的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>13)
      Factory(:rd_benefit,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end


    # -----------------内部单据--------------------

    it "收款通知单的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>3)
      Factory(:rec_notice_detail,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "结汇单据的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>4)
      Factory(:inner_remittance,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "转账单据的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>5)
      Factory(:inner_transfer,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "现金提取的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>6)
      Factory(:inner_cash_draw,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end
    
    it "购买理财产品的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>7)
      Factory(:buy_finance_product,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "赎回理财产品的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>8)
      Factory(:redeem_finance_product,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    it "固定资产单据的打印功能 should be ok" do
      doc = Factory(:doc_head,:doc_type=>14)
      Factory(:fixed_property,:doc_head=>doc)
      assign_others doc
      get "print",:doc_id=>doc.id
      response.should be_success
      response.headers["Content-Type"].should == "application/pdf" 
    end

    def assign_others doc
      Factory(:reciver,:amount=>23,:doc_head=>doc)
      Factory(:work_flow_info,:doc_head=>doc)
    end

    it "call export_to_txt by given doc_ids" do
      doc = Factory(:doc_head,:doc_type=>1)
      borrow_doc_detail = Factory(:borrow_doc_detail,:doc_head=>doc,:rate=>1,:ori_amount=>300)
      reciver1= Factory(:reciver,:doc_head=>doc,:amount=>123)
      reciver2= Factory(:reciver,:doc_head=>doc,:amount=>277)

      doc2 = Factory(:doc_head,:doc_type=>1)
      Factory(:borrow_doc_detail,:doc_head=>doc2,:rate=>1,:ori_amount=>300)
      Factory(:reciver,:doc_head=>doc2,:amount=>123)
      Factory(:reciver,:doc_head=>doc2,:amount=>277)

      get 'export_to_txt',:doc_ids=>"#{doc.id},#{doc2.id}"

      response.should be_success
      response.headers["Content-Type"].should == "text/plain"
      response.body.should include('800')
    end

    it "call export_to_txt with scope=>scope_name can export those scoped docs" do
      doc = Factory(:doc_head,:doc_type=>1,:state=>'approved')
      borrow_doc_detail = Factory(:borrow_doc_detail,:doc_head=>doc,:rate=>1,:ori_amount=>300)
      reciver1= Factory(:reciver,:doc_head=>doc,:amount=>123)
      reciver2= Factory(:reciver,:doc_head=>doc,:amount=>277)

      doc1 = Factory(:doc_head,:doc_type=>1,:state=>'paid')
      Factory(:borrow_doc_detail,:doc_head=>doc1,:rate=>1,:ori_amount=>300)
      Factory(:reciver,:doc_head=>doc1,:amount=>200)
      Factory(:reciver,:doc_head=>doc1,:amount=>900)

      get 'export_to_txt',:scope=>'approved'

      response.should be_success
      response.headers["Content-Type"].should == "text/plain"
      response.body.should include('400')

      get 'export_to_txt',:scope=>'paid'

      response.should be_success
      response.headers["Content-Type"].should == "text/plain"
      response.body.should include('1100')
    end

  end
end
