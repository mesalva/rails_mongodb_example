require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = Post.find_by(title: "one")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { body: @post.body, title: @post.title }
    end

    assert_response :created
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should update post" do
    patch :update, id: @post, post: { body: @post.body, title: @post.title }
    assert_response :ok
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_response :no_content
  end
end
