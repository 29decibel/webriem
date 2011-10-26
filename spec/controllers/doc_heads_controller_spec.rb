#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )
describe  DocHeadsController do
  describe "export docs" do

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
