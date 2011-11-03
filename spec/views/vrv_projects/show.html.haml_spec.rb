require 'spec_helper'

describe "vrv_projects/show.html.haml" do
  before(:each) do
    @vrv_project = assign(:vrv_project, stub_model(VrvProject,
      :customer => "Customer",
      :place => "Place",
      :website => "Website",
      :phone => "Phone",
      :email => "Email",
      :scale => "Scale",
      :amount => "Amount",
      :industry => "Industry",
      :agent => 1,
      :agent_contact => "Agent Contact",
      :channel => "Channel",
      :duty_description => "Duty Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Place/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Website/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Scale/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Amount/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Industry/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Agent Contact/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Channel/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Duty Description/)
  end
end
