require 'spec_helper'

describe "bill_stages/show.html.haml" do
  before(:each) do
    @bill_stage = assign(:bill_stage, stub_model(BillStage,
      :sample_choose => "Sample Choose",
      :points => "Points",
      :price_cal_way => "Price Cal Way",
      :price_sample => "Price Sample",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sample Choose/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Points/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Price Cal Way/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Price Sample/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
