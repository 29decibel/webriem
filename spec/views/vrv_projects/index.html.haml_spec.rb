require 'spec_helper'

describe "vrv_projects/index.html.haml" do
  before(:each) do
    assign(:vrv_projects, [
      stub_model(VrvProject,
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
      ),
      stub_model(VrvProject,
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
      )
    ])
  end

  it "renders a list of vrv_projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Place".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Scale".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Amount".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Industry".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Agent Contact".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Channel".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Duty Description".to_s, :count => 2
  end
end
