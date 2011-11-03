require 'spec_helper'

describe "contract_predicts/new.html.haml" do
  before(:each) do
    assign(:contract_predict, stub_model(ContractPredict,
      :product => "MyString",
      :package_num => 1,
      :points => 1.5,
      :price => 1.5,
      :vrv_project_id => 1
    ).as_new_record)
  end

  it "renders new contract_predict form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contract_predicts_path, :method => "post" do
      assert_select "input#contract_predict_product", :name => "contract_predict[product]"
      assert_select "input#contract_predict_package_num", :name => "contract_predict[package_num]"
      assert_select "input#contract_predict_points", :name => "contract_predict[points]"
      assert_select "input#contract_predict_price", :name => "contract_predict[price]"
      assert_select "input#contract_predict_vrv_project_id", :name => "contract_predict[vrv_project_id]"
    end
  end
end
