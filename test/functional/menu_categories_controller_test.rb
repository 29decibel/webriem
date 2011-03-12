require 'test_helper'

class MenuCategoriesControllerTest < ActionController::TestCase
  setup do
    @menu_category = menu_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:menu_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create menu_category" do
    assert_difference('MenuCategory.count') do
      post :create, :menu_category => @menu_category.attributes
    end

    assert_redirected_to menu_category_path(assigns(:menu_category))
  end

  test "should show menu_category" do
    get :show, :id => @menu_category.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @menu_category.to_param
    assert_response :success
  end

  test "should update menu_category" do
    put :update, :id => @menu_category.to_param, :menu_category => @menu_category.attributes
    assert_redirected_to menu_category_path(assigns(:menu_category))
  end

  test "should destroy menu_category" do
    assert_difference('MenuCategory.count', -1) do
      delete :destroy, :id => @menu_category.to_param
    end

    assert_redirected_to menu_categories_path
  end
end
