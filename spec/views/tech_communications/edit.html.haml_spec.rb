require 'spec_helper'

describe "tech_communications/edit.html.haml" do
  before(:each) do
    @tech_communication = assign(:tech_communication, stub_model(TechCommunication,
      :phone => "MyString",
      :duty => "MyString",
      :contents => "MyString",
      :feedback => "MyString",
      :has_tech_people => false,
      :our_tech_guy => "MyString",
      :tech_level => "MyString",
      :tech_attitude => "MyString",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders the edit tech_communication form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tech_communications_path(@tech_communication), :method => "post" do
      assert_select "input#tech_communication_phone", :name => "tech_communication[phone]"
      assert_select "input#tech_communication_duty", :name => "tech_communication[duty]"
      assert_select "input#tech_communication_contents", :name => "tech_communication[contents]"
      assert_select "input#tech_communication_feedback", :name => "tech_communication[feedback]"
      assert_select "input#tech_communication_has_tech_people", :name => "tech_communication[has_tech_people]"
      assert_select "input#tech_communication_our_tech_guy", :name => "tech_communication[our_tech_guy]"
      assert_select "input#tech_communication_tech_level", :name => "tech_communication[tech_level]"
      assert_select "input#tech_communication_tech_attitude", :name => "tech_communication[tech_attitude]"
      assert_select "textarea#tech_communication_others", :name => "tech_communication[others]"
      assert_select "input#tech_communication_vrv_project_id", :name => "tech_communication[vrv_project_id]"
    end
  end
end
