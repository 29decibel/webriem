require 'test_helper'

class DocHeadsControllerTest < ActionController::TestCase
  setup do
    @doc_head = doc_heads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doc_heads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doc_head" do
    assert_difference('DocHead.count') do
      post :create, :doc_head => @doc_head.attributes
    end

    assert_redirected_to doc_head_path(assigns(:doc_head))
  end

  test "should show doc_head" do
    get :show, :id => @doc_head.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @doc_head.to_param
    assert_response :success
  end

  test "should update doc_head" do
    put :update, :id => @doc_head.to_param, :doc_head => @doc_head.attributes
    assert_redirected_to doc_head_path(assigns(:doc_head))
  end

  test "should destroy doc_head" do
    assert_difference('DocHead.count', -1) do
      delete :destroy, :id => @doc_head.to_param
    end

    assert_redirected_to doc_heads_path
  end
end
