require 'spec_helper'

describe "customer_contacts/edit.html.haml" do
  before(:each) do
    @customer_contact = assign(:customer_contact, stub_model(CustomerContact,
      :name => "MyString",
      :duty => "MyString",
      :phone => "MyString",
      :vrv_project_id => 1
    ))
  end

  it "renders the edit customer_contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => customer_contacts_path(@customer_contact), :method => "post" do
      assert_select "input#customer_contact_name", :name => "customer_contact[name]"
      assert_select "input#customer_contact_duty", :name => "customer_contact[duty]"
      assert_select "input#customer_contact_phone", :name => "customer_contact[phone]"
      assert_select "input#customer_contact_vrv_project_id", :name => "customer_contact[vrv_project_id]"
    end
  end
end