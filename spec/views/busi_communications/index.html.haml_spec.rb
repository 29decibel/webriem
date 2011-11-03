require 'spec_helper'

describe "busi_communications/index.html.haml" do
  before(:each) do
    assign(:busi_communications, [
      stub_model(BusiCommunication,
        :person => "Person",
        :duty => "Duty",
        :phone => "Phone",
        :way => "Way",
        :feedback => "Feedback",
        :others => "MyText",
        :vrv_project_id => 1
      ),
      stub_model(BusiCommunication,
        :person => "Person",
        :duty => "Duty",
        :phone => "Phone",
        :way => "Way",
        :feedback => "Feedback",
        :others => "MyText",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of busi_communications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Person".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Duty".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Way".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Feedback".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
