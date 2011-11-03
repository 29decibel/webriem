require 'spec_helper'

describe "bill_afters/index.html.haml" do
  before(:each) do
    assign(:bill_afters, [
      stub_model(BillAfter,
        :bill_state => "Bill State",
        :contract => "Contract",
        :money_back => "Money Back",
        :others => "MyText",
        :bill_price => 1.5,
        :vrv_project_id => 1
      ),
      stub_model(BillAfter,
        :bill_state => "Bill State",
        :contract => "Contract",
        :money_back => "Money Back",
        :others => "MyText",
        :bill_price => 1.5,
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of bill_afters" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Bill State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Contract".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Money Back".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
