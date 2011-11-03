require 'spec_helper'

describe "busi_communications/show.html.haml" do
  before(:each) do
    @busi_communication = assign(:busi_communication, stub_model(BusiCommunication,
      :person => "Person",
      :duty => "Duty",
      :phone => "Phone",
      :way => "Way",
      :feedback => "Feedback",
      :others => "MyText",
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Person/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Duty/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Way/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Feedback/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
