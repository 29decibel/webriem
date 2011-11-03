require 'spec_helper'

describe "customer_contacts/index.html.haml" do
  before(:each) do
    assign(:customer_contacts, [
      stub_model(CustomerContact,
        :name => "Name",
        :duty => "Duty",
        :phone => "Phone",
        :vrv_project_id => 1
      ),
      stub_model(CustomerContact,
        :name => "Name",
        :duty => "Duty",
        :phone => "Phone",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of customer_contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Duty".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
