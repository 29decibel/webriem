require 'test_helper'

class ExtraWorkStandardsControllerTest < ActionController::TestCase
  setup do
    @extra_work_standard = extra_work_standards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:extra_work_standards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create extra_work_standard" do
    assert_difference('ExtraWorkStandard.count') do
      post :create, :extra_work_standard => @extra_work_standard.attributes
    end

    assert_redirected_to extra_work_standard_path(assigns(:extra_work_standard))
  end

  test "should show extra_work_standard" do
    get :show, :id => @extra_work_standard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @extra_work_standard.to_param
    assert_response :success
  end

  test "should update extra_work_standard" do
    put :update, :id => @extra_work_standard.to_param, :extra_work_standard => @extra_work_standard.attributes
    assert_redirected_to extra_work_standard_path(assigns(:extra_work_standard))
  end

  test "should destroy extra_work_standard" do
    assert_difference('ExtraWorkStandard.count', -1) do
      delete :destroy, :id => @extra_work_standard.to_param
    end

    assert_redirected_to extra_work_standards_path
  end
end
