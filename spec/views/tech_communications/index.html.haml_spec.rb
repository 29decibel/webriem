require 'spec_helper'

describe "tech_communications/index.html.haml" do
  before(:each) do
    assign(:tech_communications, [
      stub_model(TechCommunication,
        :phone => "Phone",
        :duty => "Duty",
        :contents => "Contents",
        :feedback => "Feedback",
        :has_tech_people => false,
        :our_tech_guy => "Our Tech Guy",
        :tech_level => "Tech Level",
        :tech_attitude => "Tech Attitude",
        :others => "MyText",
        :vrv_project_id => 1
      ),
      stub_model(TechCommunication,
        :phone => "Phone",
        :duty => "Duty",
        :contents => "Contents",
        :feedback => "Feedback",
        :has_tech_people => false,
        :our_tech_guy => "Our Tech Guy",
        :tech_level => "Tech Level",
        :tech_attitude => "Tech Attitude",
        :others => "MyText",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of tech_communications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Duty".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Contents".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Feedback".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Our Tech Guy".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tech Level".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Tech Attitude".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
