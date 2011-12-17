require 'spec_helper'

describe "bxy_projects/show.html.haml" do
  before(:each) do
    @bxy_project = assign(:bxy_project, stub_model(BxyProject,
      :name => "Name",
      :code => "Code",
      :customer => "Customer",
      :contact_person => "Contact Person",
      :person_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Contact Person/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
