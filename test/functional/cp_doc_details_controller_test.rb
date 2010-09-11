require 'test_helper'

class CpDocDetailsControllerTest < ActionController::TestCase
  setup do
    @cp_doc_detail = cp_doc_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cp_doc_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cp_doc_detail" do
    assert_difference('CpDocDetail.count') do
      post :create, :cp_doc_detail => @cp_doc_detail.attributes
    end

    assert_redirected_to cp_doc_detail_path(assigns(:cp_doc_detail))
  end

  test "should show cp_doc_detail" do
    get :show, :id => @cp_doc_detail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cp_doc_detail.to_param
    assert_response :success
  end

  test "should update cp_doc_detail" do
    put :update, :id => @cp_doc_detail.to_param, :cp_doc_detail => @cp_doc_detail.attributes
    assert_redirected_to cp_doc_detail_path(assigns(:cp_doc_detail))
  end

  test "should destroy cp_doc_detail" do
    assert_difference('CpDocDetail.count', -1) do
      delete :destroy, :id => @cp_doc_detail.to_param
    end

    assert_redirected_to cp_doc_details_path
  end
end
