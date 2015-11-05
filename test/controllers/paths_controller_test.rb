require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  setup do
    @path = Path.create(structure: {:cat => 1})
  end

  test "should get index" do
    get :index

    assert_response :success
    assert_not_nil assigns(:paths)
  end

  test "should create path" do
    assert_difference('Path.count') do
      post :create, path: { structure: @path.structure }
    end
    assert_response :created
  end

  test "should show path" do
    get :show, id: @path
    assert_response :success
  end

  test "should update path" do
    patch :update, id: @path, path: { structure: @path.structure }
    assert_response :ok
  end

  test "should destroy path" do
    assert_difference('Path.count', -1) do
      delete :destroy, id: @path
    end

    assert_response :no_content
  end
end
