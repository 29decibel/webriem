require 'spec_helper'

describe "bill_prepares/edit.html.haml" do
  before(:each) do
    @bill_prepare = assign(:bill_prepare, stub_model(BillPrepare,
      :sample_choose => "MyString",
      :price_point => "MyString",
      :price_cal_way => "MyString",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders the edit bill_prepare form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bill_prepares_path(@bill_prepare), :method => "post" do
      assert_select "input#bill_prepare_sample_choose", :name => "bill_prepare[sample_choose]"
      assert_select "input#bill_prepare_price_point", :name => "bill_prepare[price_point]"
      assert_select "input#bill_prepare_price_cal_way", :name => "bill_prepare[price_cal_way]"
      assert_select "textarea#bill_prepare_others", :name => "bill_prepare[others]"
      assert_select "input#bill_prepare_vrv_project_id", :name => "bill_prepare[vrv_project_id]"
    end
  end
end
