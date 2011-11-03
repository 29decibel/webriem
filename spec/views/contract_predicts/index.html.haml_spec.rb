require 'spec_helper'

describe "contract_predicts/index.html.haml" do
  before(:each) do
    assign(:contract_predicts, [
      stub_model(ContractPredict,
        :product => "Product",
        :package_num => 1,
        :points => 1.5,
        :price => 1.5,
        :vrv_project_id => 1
      ),
      stub_model(ContractPredict,
        :product => "Product",
        :package_num => 1,
        :points => 1.5,
        :price => 1.5,
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of contract_predicts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Product".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
