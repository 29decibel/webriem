require 'spec_helper'

describe "network_conditions/show.html.haml" do
  before(:each) do
    @network_condition = assign(:network_condition, stub_model(NetworkCondition,
      :ip_address => "Ip Address",
      :hub => "Hub",
      :dns_server => "Dns Server",
      :windows_domain => "Windows Domain",
      :network_connection => "Network Connection",
      :physical_keep => "Physical Keep",
      :port_listen => "Port Listen",
      :network_inside => "Network Inside",
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Ip Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hub/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Dns Server/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Windows Domain/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Network Connection/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Physical Keep/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Port Listen/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Network Inside/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
