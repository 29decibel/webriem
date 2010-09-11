require 'test_helper'

class ReciversControllerTest < ActionController::TestCase
  setup do
    @reciver = recivers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recivers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reciver" do
    assert_difference('Reciver.count') do
      post :create, :reciver => @reciver.attributes
    end

    assert_redirected_to reciver_path(assigns(:reciver))
  end

  test "should show reciver" do
    get :show, :id => @reciver.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @reciver.to_param
    assert_response :success
  end

  test "should update reciver" do
    put :update, :id => @reciver.to_param, :reciver => @reciver.attributes
    assert_redirected_to reciver_path(assigns(:reciver))
  end

  test "should destroy reciver" do
    assert_difference('Reciver.count', -1) do
      delete :destroy, :id => @reciver.to_param
    end

    assert_redirected_to recivers_path
  end
end
