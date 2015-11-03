require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.find_by(name: "user_one")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end


  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: @user.name, points: @user.points, user_id: 99 }
    end

    assert_response :created
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { name: @user.name, points: @user.points, user_id: @user.user_id }
    assert_response :ok
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_response :no_content
  end

  test "should validate params" do
    post :create, user: { name: @user.name, points: @user.points }
    assert_response :unprocessable_entity
  end
end
