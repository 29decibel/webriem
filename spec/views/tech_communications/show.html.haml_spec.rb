require 'spec_helper'

describe "tech_communications/show.html.haml" do
  before(:each) do
    @tech_communication = assign(:tech_communication, stub_model(TechCommunication,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Duty/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Contents/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Feedback/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Our Tech Guy/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tech Level/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Tech Attitude/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
