require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  test "should get reset_p" do
    get :reset_p
    assert_response :success
  end

end
