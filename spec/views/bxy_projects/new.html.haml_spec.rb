require 'spec_helper'

describe "bxy_projects/new.html.haml" do
  before(:each) do
    assign(:bxy_project, stub_model(BxyProject,
      :name => "MyString",
      :code => "MyString",
      :customer => "MyString",
      :contact_person => "MyString",
      :person_id => 1
    ).as_new_record)
  end

  it "renders new bxy_project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bxy_projects_path, :method => "post" do
      assert_select "input#bxy_project_name", :name => "bxy_project[name]"
      assert_select "input#bxy_project_code", :name => "bxy_project[code]"
      assert_select "input#bxy_project_customer", :name => "bxy_project[customer]"
      assert_select "input#bxy_project_contact_person", :name => "bxy_project[contact_person]"
      assert_select "input#bxy_project_person_id", :name => "bxy_project[person_id]"
    end
  end
end
