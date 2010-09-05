require 'test_helper'

class FeesControllerTest < ActionController::TestCase
  setup do
    @fee = fees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fee" do
    assert_difference('Fee.count') do
      post :create, :fee => @fee.attributes
    end

    assert_redirected_to fee_path(assigns(:fee))
  end

  test "should show fee" do
    get :show, :id => @fee.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fee.to_param
    assert_response :success
  end

  test "should update fee" do
    put :update, :id => @fee.to_param, :fee => @fee.attributes
    assert_redirected_to fee_path(assigns(:fee))
  end

  test "should destroy fee" do
    assert_difference('Fee.count', -1) do
      delete :destroy, :id => @fee.to_param
    end

    assert_redirected_to fees_path
  end
end
