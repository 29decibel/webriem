require 'spec_helper'

describe "bill_afters/show.html.haml" do
  before(:each) do
    @bill_after = assign(:bill_after, stub_model(BillAfter,
      :bill_state => "Bill State",
      :contract => "Contract",
      :money_back => "Money Back",
      :others => "MyText",
      :bill_price => 1.5,
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Bill State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Contract/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Money Back/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
