require 'spec_helper'

describe "product_tests/new.html.haml" do
  before(:each) do
    assign(:product_test, stub_model(ProductTest,
      :customer => "MyString",
      :sample => "MyString",
      :sample_state => "MyString",
      :customer_attitude => "MyString",
      :test_result => "MyString",
      :has_tech_people => false,
      :our_tech_guy => "MyString",
      :our_tech_phone => "MyString",
      :tech_people_point => "MyString",
      :test_product_order => "MyString",
      :customer_like => "MyString",
      :others => "MyText",
      :vrv_project_id => 1
    ).as_new_record)
  end

  it "renders new product_test form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => product_tests_path, :method => "post" do
      assert_select "input#product_test_customer", :name => "product_test[customer]"
      assert_select "input#product_test_sample", :name => "product_test[sample]"
      assert_select "input#product_test_sample_state", :name => "product_test[sample_state]"
      assert_select "input#product_test_customer_attitude", :name => "product_test[customer_attitude]"
      assert_select "input#product_test_test_result", :name => "product_test[test_result]"
      assert_select "input#product_test_has_tech_people", :name => "product_test[has_tech_people]"
      assert_select "input#product_test_our_tech_guy", :name => "product_test[our_tech_guy]"
      assert_select "input#product_test_our_tech_phone", :name => "product_test[our_tech_phone]"
      assert_select "input#product_test_tech_people_point", :name => "product_test[tech_people_point]"
      assert_select "input#product_test_test_product_order", :name => "product_test[test_product_order]"
      assert_select "input#product_test_customer_like", :name => "product_test[customer_like]"
      assert_select "textarea#product_test_others", :name => "product_test[others]"
      assert_select "input#product_test_vrv_project_id", :name => "product_test[vrv_project_id]"
    end
  end
end
