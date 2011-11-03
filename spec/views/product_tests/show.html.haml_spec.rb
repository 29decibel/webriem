require 'spec_helper'

describe "product_tests/show.html.haml" do
  before(:each) do
    @product_test = assign(:product_test, stub_model(ProductTest,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sample/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sample State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer Attitude/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Test Result/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Our Tech Guy/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Our Tech Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tech People Point/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Test Product Order/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer Like/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
