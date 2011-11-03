require 'spec_helper'

describe "bill_stages/edit.html.haml" do
  before(:each) do
    @bill_stage = assign(:bill_stage, stub_model(BillStage,
      :sample_choose => "MyString",
      :points => "MyString",
      :price_cal_way => "MyString",
      :price_sample => "MyString",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders the edit bill_stage form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bill_stages_path(@bill_stage), :method => "post" do
      assert_select "input#bill_stage_sample_choose", :name => "bill_stage[sample_choose]"
      assert_select "input#bill_stage_points", :name => "bill_stage[points]"
      assert_select "input#bill_stage_price_cal_way", :name => "bill_stage[price_cal_way]"
      assert_select "input#bill_stage_price_sample", :name => "bill_stage[price_sample]"
      assert_select "textarea#bill_stage_others", :name => "bill_stage[others]"
      assert_select "input#bill_stage_vrv_project_id", :name => "bill_stage[vrv_project_id]"
    end
  end
end
