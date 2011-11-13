require 'spec_helper'

describe "doc_amount_changes/index.html.haml" do
  before(:each) do
    assign(:doc_amount_changes, [
      stub_model(DocAmountChange,
        :resource_class => "Resource Class",
        :resource_id => 1,
        :new_amount => "9.99",
        :person_id => 1,
        :doc_head_id => 1
      ),
      stub_model(DocAmountChange,
        :resource_class => "Resource Class",
        :resource_id => 1,
        :new_amount => "9.99",
        :person_id => 1,
        :doc_head_id => 1
      )
    ])
  end

  it "renders a list of doc_amount_changes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Resource Class".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
