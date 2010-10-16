require 'test_helper'

class ModelSearchControllerTest < ActionController::TestCase
  test "should get with" do
    get :with
    assert_response :success
  end

end
