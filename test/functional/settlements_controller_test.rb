require 'test_helper'

class SettlementsControllerTest < ActionController::TestCase
  setup do
    @settlement = settlements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:settlements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create settlement" do
    assert_difference('Settlement.count') do
      post :create, :settlement => @settlement.attributes
    end

    assert_redirected_to settlement_path(assigns(:settlement))
  end

  test "should show settlement" do
    get :show, :id => @settlement.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @settlement.to_param
    assert_response :success
  end

  test "should update settlement" do
    put :update, :id => @settlement.to_param, :settlement => @settlement.attributes
    assert_redirected_to settlement_path(assigns(:settlement))
  end

  test "should destroy settlement" do
    assert_difference('Settlement.count', -1) do
      delete :destroy, :id => @settlement.to_param
    end

    assert_redirected_to settlements_path
  end
end
