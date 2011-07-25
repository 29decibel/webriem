#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )

describe RdTravel do
  it "should change the recivers hr amount or the fi amount to a right one" do
    doc = Factory(:doc_head,:doc_type=>9)
    rd_travel1 = Factory(:rd_travel,:doc_head=>doc,:rate=>1,:ori_amount=>600)
    rd_travel2 = Factory(:rd_travel,:doc_head=>doc,:rate=>1,:ori_amount=>400)

    reciver1 = Factory(:reciver,:doc_head=>doc,:amount=>300)
    reciver2 = Factory(:reciver,:doc_head=>doc,:amount=>300)
    reciver3 = Factory(:reciver,:doc_head=>doc,:amount=>400)

    rd_travel1.adjust_amount :hr_amount,100

    #relaod
    rd_travel1.reload
    reciver1.reload
    reciver2.reload
    reciver3.reload

    rd_travel1.hr_amount.should == 100

    reciver1.hr_amount.should == 0
    reciver2.hr_amount.should == 100

    #change again
    rd_travel1.adjust_amount :hr_amount,200
    reciver1.reload
    rd_travel1.reload

    rd_travel1.hr_amount.should == 200
    reciver1.hr_amount.should == 100

    # now change the fi amount ============
    rd_travel1.adjust_amount :fi_amount,100

    #relaod
    rd_travel1.reload
    reciver1.reload
    reciver2.reload
    reciver3.reload

    rd_travel1.fi_amount.should == 100

    reciver1.fi_amount.should == 0
    reciver2.fi_amount.should == 100

    #change again
    rd_travel1.adjust_amount :fi_amount,200
    reciver1.reload
    rd_travel1.reload

    rd_travel1.fi_amount.should == 200
    reciver1.fi_amount.should == 100
  end

end
