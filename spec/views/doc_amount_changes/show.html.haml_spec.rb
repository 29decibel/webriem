require 'spec_helper'

describe "doc_amount_changes/show.html.haml" do
  before(:each) do
    @doc_amount_change = assign(:doc_amount_change, stub_model(DocAmountChange,
      :resource_class => "Resource Class",
      :resource_id => 1,
      :new_amount => "9.99",
      :person_id => 1,
      :doc_head_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Resource Class/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/9.99/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
