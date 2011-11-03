require 'spec_helper'

describe "bill_prepares/show.html.haml" do
  before(:each) do
    @bill_prepare = assign(:bill_prepare, stub_model(BillPrepare,
      :sample_choose => "Sample Choose",
      :price_point => "Price Point",
      :price_cal_way => "Price Cal Way",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Sample Choose/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Price Point/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Price Cal Way/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
