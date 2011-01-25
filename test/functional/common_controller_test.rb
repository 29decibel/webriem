require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  test "should get new_reset_p" do
    get :new_reset_p
    assert_response :success
  end

end
