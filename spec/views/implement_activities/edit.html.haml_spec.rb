require 'spec_helper'

describe "implement_activities/edit.html.haml" do
  before(:each) do
    @implement_activity = assign(:implement_activity, stub_model(ImplementActivity,
      :engineer => "MyString",
      :days => 1.5,
      :vrv_project_id => 1
    ))
  end

  it "renders the edit implement_activity form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => implement_activities_path(@implement_activity), :method => "post" do
      assert_select "input#implement_activity_engineer", :name => "implement_activity[engineer]"
      assert_select "input#implement_activity_days", :name => "implement_activity[days]"
      assert_select "input#implement_activity_vrv_project_id", :name => "implement_activity[vrv_project_id]"
    end
  end
end
