require 'spec_helper'

describe "vrv_projects/new.html.haml" do
  before(:each) do
    assign(:vrv_project, stub_model(VrvProject,
      :customer => "MyString",
      :place => "MyString",
      :website => "MyString",
      :phone => "MyString",
      :email => "MyString",
      :scale => "MyString",
      :amount => "MyString",
      :industry => "MyString",
      :agent => 1,
      :agent_contact => "MyString",
      :channel => "MyString",
      :duty_description => "MyString"
    ).as_new_record)
  end

  it "renders new vrv_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => vrv_projects_path, :method => "post" do
      assert_select "input#vrv_project_customer", :name => "vrv_project[customer]"
      assert_select "input#vrv_project_place", :name => "vrv_project[place]"
      assert_select "input#vrv_project_website", :name => "vrv_project[website]"
      assert_select "input#vrv_project_phone", :name => "vrv_project[phone]"
      assert_select "input#vrv_project_email", :name => "vrv_project[email]"
      assert_select "input#vrv_project_scale", :name => "vrv_project[scale]"
      assert_select "input#vrv_project_amount", :name => "vrv_project[amount]"
      assert_select "input#vrv_project_industry", :name => "vrv_project[industry]"
      assert_select "input#vrv_project_agent", :name => "vrv_project[agent]"
      assert_select "input#vrv_project_agent_contact", :name => "vrv_project[agent_contact]"
      assert_select "input#vrv_project_channel", :name => "vrv_project[channel]"
      assert_select "input#vrv_project_duty_description", :name => "vrv_project[duty_description]"
    end
  end
end
