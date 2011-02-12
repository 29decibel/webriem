require 'test_helper'

class FeeCodeMatchesControllerTest < ActionController::TestCase
  setup do
    @fee_code_match = fee_code_matches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fee_code_matches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fee_code_match" do
    assert_difference('FeeCodeMatch.count') do
      post :create, :fee_code_match => @fee_code_match.attributes
    end

    assert_redirected_to fee_code_match_path(assigns(:fee_code_match))
  end

  test "should show fee_code_match" do
    get :show, :id => @fee_code_match.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fee_code_match.to_param
    assert_response :success
  end

  test "should update fee_code_match" do
    put :update, :id => @fee_code_match.to_param, :fee_code_match => @fee_code_match.attributes
    assert_redirected_to fee_code_match_path(assigns(:fee_code_match))
  end

  test "should destroy fee_code_match" do
    assert_difference('FeeCodeMatch.count', -1) do
      delete :destroy, :id => @fee_code_match.to_param
    end

    assert_redirected_to fee_code_matches_path
  end
end
