require 'spec_helper'

describe "competitors/index.html.haml" do
  before(:each) do
    assign(:competitors, [
      stub_model(Competitor,
        :name => "Name",
        :agent => "Agent",
        :price => 1.5,
        :vrv_project_id => 1
      ),
      stub_model(Competitor,
        :name => "Name",
        :agent => "Agent",
        :price => 1.5,
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of competitors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Agent".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
