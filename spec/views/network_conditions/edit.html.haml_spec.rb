require 'spec_helper'

describe "network_conditions/edit.html.haml" do
  before(:each) do
    @network_condition = assign(:network_condition, stub_model(NetworkCondition,
      :ip_address => "MyString",
      :hub => "MyString",
      :dns_server => "MyString",
      :windows_domain => "MyString",
      :network_connection => "MyString",
      :physical_keep => "MyString",
      :port_listen => "MyString",
      :network_inside => "MyString",
      :vrv_project_id => 1
    ))
  end

  it "renders the edit network_condition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => network_conditions_path(@network_condition), :method => "post" do
      assert_select "input#network_condition_ip_address", :name => "network_condition[ip_address]"
      assert_select "input#network_condition_hub", :name => "network_condition[hub]"
      assert_select "input#network_condition_dns_server", :name => "network_condition[dns_server]"
      assert_select "input#network_condition_windows_domain", :name => "network_condition[windows_domain]"
      assert_select "input#network_condition_network_connection", :name => "network_condition[network_connection]"
      assert_select "input#network_condition_physical_keep", :name => "network_condition[physical_keep]"
      assert_select "input#network_condition_port_listen", :name => "network_condition[port_listen]"
      assert_select "input#network_condition_network_inside", :name => "network_condition[network_inside]"
      assert_select "input#network_condition_vrv_project_id", :name => "network_condition[vrv_project_id]"
    end
  end
end
