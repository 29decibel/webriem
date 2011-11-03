require 'spec_helper'

describe "bill_prepares/index.html.haml" do
  before(:each) do
    assign(:bill_prepares, [
      stub_model(BillPrepare,
        :sample_choose => "Sample Choose",
        :price_point => "Price Point",
        :price_cal_way => "Price Cal Way",
        :others => "MyText",
        :vrv_project_id => 1
      ),
      stub_model(BillPrepare,
        :sample_choose => "Sample Choose",
        :price_point => "Price Point",
        :price_cal_way => "Price Cal Way",
        :others => "MyText",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of bill_prepares" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Sample Choose".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Price Point".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Price Cal Way".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
