require 'test_helper'

class TransportationsControllerTest < ActionController::TestCase
  setup do
    @transportation = transportations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transportations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transportation" do
    assert_difference('Transportation.count') do
      post :create, :transportation => @transportation.attributes
    end

    assert_redirected_to transportation_path(assigns(:transportation))
  end

  test "should show transportation" do
    get :show, :id => @transportation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @transportation.to_param
    assert_response :success
  end

  test "should update transportation" do
    put :update, :id => @transportation.to_param, :transportation => @transportation.attributes
    assert_redirected_to transportation_path(assigns(:transportation))
  end

  test "should destroy transportation" do
    assert_difference('Transportation.count', -1) do
      delete :destroy, :id => @transportation.to_param
    end

    assert_redirected_to transportations_path
  end
end
