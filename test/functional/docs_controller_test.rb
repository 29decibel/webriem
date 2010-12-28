require 'test_helper'

class DocsControllerTest < ActionController::TestCase
  test "should get my_docs" do
    get :my_docs
    assert_response :success
  end

end
