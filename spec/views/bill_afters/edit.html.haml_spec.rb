require 'spec_helper'

describe "bill_afters/edit.html.haml" do
  before(:each) do
    @bill_after = assign(:bill_after, stub_model(BillAfter,
      :bill_state => "MyString",
      :contract => "MyString",
      :money_back => "MyString",
      :others => "MyText",
      :bill_price => 1.5,
      :vrv_project_id => 1
    ))
  end

  it "renders the edit bill_after form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bill_afters_path(@bill_after), :method => "post" do
      assert_select "input#bill_after_bill_state", :name => "bill_after[bill_state]"
      assert_select "input#bill_after_contract", :name => "bill_after[contract]"
      assert_select "input#bill_after_money_back", :name => "bill_after[money_back]"
      assert_select "textarea#bill_after_others", :name => "bill_after[others]"
      assert_select "input#bill_after_bill_price", :name => "bill_after[bill_price]"
      assert_select "input#bill_after_vrv_project_id", :name => "bill_after[vrv_project_id]"
    end
  end
end
