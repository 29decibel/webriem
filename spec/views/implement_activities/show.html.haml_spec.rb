require 'spec_helper'

describe "implement_activities/show.html.haml" do
  before(:each) do
    @implement_activity = assign(:implement_activity, stub_model(ImplementActivity,
      :engineer => "Engineer",
      :days => 1.5,
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Engineer/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
