require 'spec_helper'

describe "doc_amount_changes/new.html.haml" do
  before(:each) do
    assign(:doc_amount_change, stub_model(DocAmountChange,
      :resource_class => "MyString",
      :resource_id => 1,
      :new_amount => "9.99",
      :person_id => 1,
      :doc_head_id => 1
    ).as_new_record)
  end

  it "renders new doc_amount_change form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => doc_amount_changes_path, :method => "post" do
      assert_select "input#doc_amount_change_resource_class", :name => "doc_amount_change[resource_class]"
      assert_select "input#doc_amount_change_resource_id", :name => "doc_amount_change[resource_id]"
      assert_select "input#doc_amount_change_new_amount", :name => "doc_amount_change[new_amount]"
      assert_select "input#doc_amount_change_person_id", :name => "doc_amount_change[person_id]"
      assert_select "input#doc_amount_change_doc_head_id", :name => "doc_amount_change[doc_head_id]"
    end
  end
end
