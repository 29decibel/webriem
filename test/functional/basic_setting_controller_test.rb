require 'test_helper'

class BasicSettingControllerTest < ActionController::TestCase
  test "should get dep" do
    get :dep
    assert_response :success
  end

end
