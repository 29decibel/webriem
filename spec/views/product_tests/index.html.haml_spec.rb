require 'spec_helper'

describe "product_tests/index.html.haml" do
  before(:each) do
    assign(:product_tests, [
      stub_model(ProductTest,
        :customer => "Customer",
        :sample => "Sample",
        :sample_state => "Sample State",
        :customer_attitude => "Customer Attitude",
        :test_result => "Test Result",
        :has_tech_people => false,
        :our_tech_guy => "Our Tech Guy",
        :our_tech_phone => "Our Tech Phone",
        :tech_people_point => "Tech People Point",
        :test_product_order => "Test Product Order",
        :customer_like => "Customer Like",
        :others => "MyText",
        :vrv_project_id => 1
      ),
      stub_model(ProductTest,
        :customer => "Customer",
        :sample => "Sample",
        :sample_state => "Sample State",
        :customer_attitude => "Customer Attitude",
        :test_result => "Test Result",
        :has_tech_people => false,
        :our_tech_guy => "Our Tech Guy",
        :our_tech_phone => "Our Tech Phone",
        :tech_people_point => "Tech People Point",
        :test_product_order => "Test Product Order",
        :customer_like => "Customer Like",
        :others => "MyText",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of product_tests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Sample".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Sample State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer Attitude".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Test Result".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Our Tech Guy".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Our Tech Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tech People Point".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Test Product Order".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer Like".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
