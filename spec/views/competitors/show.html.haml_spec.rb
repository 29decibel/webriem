require 'spec_helper'

describe "competitors/show.html.haml" do
  before(:each) do
    @competitor = assign(:competitor, stub_model(Competitor,
      :name => "Name",
      :agent => "Agent",
      :price => 1.5,
      :vrv_project_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Agent/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
