require 'spec_helper'

describe "bxy_projects/index.html.haml" do
  before(:each) do
    assign(:bxy_projects, [
      stub_model(BxyProject,
        :name => "Name",
        :code => "Code",
        :customer => "Customer",
        :contact_person => "Contact Person",
        :person_id => 1
      ),
      stub_model(BxyProject,
        :name => "Name",
        :code => "Code",
        :customer => "Customer",
        :contact_person => "Contact Person",
        :person_id => 1
      )
    ])
  end

  it "renders a list of bxy_projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Contact Person".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
