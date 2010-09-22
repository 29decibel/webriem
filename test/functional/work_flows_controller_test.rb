require 'test_helper'

class WorkFlowsControllerTest < ActionController::TestCase
  setup do
    @work_flow = work_flows(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_flows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_flow" do
    assert_difference('WorkFlow.count') do
      post :create, :work_flow => @work_flow.attributes
    end

    assert_redirected_to work_flow_path(assigns(:work_flow))
  end

  test "should show work_flow" do
    get :show, :id => @work_flow.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @work_flow.to_param
    assert_response :success
  end

  test "should update work_flow" do
    put :update, :id => @work_flow.to_param, :work_flow => @work_flow.attributes
    assert_redirected_to work_flow_path(assigns(:work_flow))
  end

  test "should destroy work_flow" do
    assert_difference('WorkFlow.count', -1) do
      delete :destroy, :id => @work_flow.to_param
    end

    assert_redirected_to work_flows_path
  end
end
