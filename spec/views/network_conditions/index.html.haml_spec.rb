require 'spec_helper'

describe "network_conditions/index.html.haml" do
  before(:each) do
    assign(:network_conditions, [
      stub_model(NetworkCondition,
        :ip_address => "Ip Address",
        :hub => "Hub",
        :dns_server => "Dns Server",
        :windows_domain => "Windows Domain",
        :network_connection => "Network Connection",
        :physical_keep => "Physical Keep",
        :port_listen => "Port Listen",
        :network_inside => "Network Inside",
        :vrv_project_id => 1
      ),
      stub_model(NetworkCondition,
        :ip_address => "Ip Address",
        :hub => "Hub",
        :dns_server => "Dns Server",
        :windows_domain => "Windows Domain",
        :network_connection => "Network Connection",
        :physical_keep => "Physical Keep",
        :port_listen => "Port Listen",
        :network_inside => "Network Inside",
        :vrv_project_id => 1
      )
    ])
  end

  it "renders a list of network_conditions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Ip Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hub".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Dns Server".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Windows Domain".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Network Connection".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Physical Keep".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Port Listen".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Network Inside".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
