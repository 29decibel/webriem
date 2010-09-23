require 'test_helper'

class WorkFlowInfosControllerTest < ActionController::TestCase
  setup do
    @work_flow_info = work_flow_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_flow_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_flow_info" do
    assert_difference('WorkFlowInfo.count') do
      post :create, :work_flow_info => @work_flow_info.attributes
    end

    assert_redirected_to work_flow_info_path(assigns(:work_flow_info))
  end

  test "should show work_flow_info" do
    get :show, :id => @work_flow_info.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @work_flow_info.to_param
    assert_response :success
  end

  test "should update work_flow_info" do
    put :update, :id => @work_flow_info.to_param, :work_flow_info => @work_flow_info.attributes
    assert_redirected_to work_flow_info_path(assigns(:work_flow_info))
  end

  test "should destroy work_flow_info" do
    assert_difference('WorkFlowInfo.count', -1) do
      delete :destroy, :id => @work_flow_info.to_param
    end

    assert_redirected_to work_flow_infos_path
  end
end
