require 'spec_helper'

describe "customer_contacts/show.html.haml" do
  before(:each) do
    @customer_contact = assign(:customer_contact, stub_model(CustomerContact,
      :name => "Name",
      :duty => "Duty",
      :phone => "Phone",
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Duty/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
