require 'spec_helper'

describe "busi_communications/new.html.haml" do
  before(:each) do
    assign(:busi_communication, stub_model(BusiCommunication,
      :person => "MyString",
      :duty => "MyString",
      :phone => "MyString",
      :way => "MyString",
      :feedback => "MyString",
      :others => "MyText",
      :vrv_project_id => 1
    ).as_new_record)
  end

  it "renders new busi_communication form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => busi_communications_path, :method => "post" do
      assert_select "input#busi_communication_person", :name => "busi_communication[person]"
      assert_select "input#busi_communication_duty", :name => "busi_communication[duty]"
      assert_select "input#busi_communication_phone", :name => "busi_communication[phone]"
      assert_select "input#busi_communication_way", :name => "busi_communication[way]"
      assert_select "input#busi_communication_feedback", :name => "busi_communication[feedback]"
      assert_select "textarea#busi_communication_others", :name => "busi_communication[others]"
      assert_select "input#busi_communication_vrv_project_id", :name => "busi_communication[vrv_project_id]"
    end
  end
end
