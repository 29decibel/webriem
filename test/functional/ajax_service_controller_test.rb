require 'test_helper'

class AjaxServiceControllerTest < ActionController::TestCase
  test "should get getfee" do
    get :getfee
    assert_response :success
  end

end
