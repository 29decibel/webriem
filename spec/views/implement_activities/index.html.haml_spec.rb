require 'spec_helper'

describe "implement_activities/index.html.haml" do
  before(:each) do
    assign(:implement_activities, [
      stub_model(ImplementActivity,
        :engineer => "Engineer",
        :days => 1.5,
        :vrv_project_id => 1
      ),
      stub_model(ImplementActivity,
        :engineer => "Engineer",
        :days => 1.5,
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of implement_activities" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Engineer".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
