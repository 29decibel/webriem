require 'test_helper'

class FeeStandardsControllerTest < ActionController::TestCase
  setup do
    @fee_standard = fee_standards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fee_standards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fee_standard" do
    assert_difference('FeeStandard.count') do
      post :create, :fee_standard => @fee_standard.attributes
    end

    assert_redirected_to fee_standard_path(assigns(:fee_standard))
  end

  test "should show fee_standard" do
    get :show, :id => @fee_standard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fee_standard.to_param
    assert_response :success
  end

  test "should update fee_standard" do
    put :update, :id => @fee_standard.to_param, :fee_standard => @fee_standard.attributes
    assert_redirected_to fee_standard_path(assigns(:fee_standard))
  end

  test "should destroy fee_standard" do
    assert_difference('FeeStandard.count', -1) do
      delete :destroy, :id => @fee_standard.to_param
    end

    assert_redirected_to fee_standards_path
  end
end
