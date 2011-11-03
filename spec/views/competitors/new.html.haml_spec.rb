require 'spec_helper'

describe "competitors/new.html.haml" do
  before(:each) do
    assign(:competitor, stub_model(Competitor,
      :name => "MyString",
      :agent => "MyString",
      :price => 1.5,
      :vrv_project_id => 1
    ).as_new_record)
  end

  it "renders new competitor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => competitors_path, :method => "post" do
      assert_select "input#competitor_name", :name => "competitor[name]"
      assert_select "input#competitor_agent", :name => "competitor[agent]"
      assert_select "input#competitor_price", :name => "competitor[price]"
      assert_select "input#competitor_vrv_project_id", :name => "competitor[vrv_project_id]"
    end
  end
end
