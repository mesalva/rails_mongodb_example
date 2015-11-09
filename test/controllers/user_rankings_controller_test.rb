require 'test_helper'

class UserRankingsControllerTest < ActionController::TestCase
  setup do
    @user_ranking = UserRanking.find_by(path: "aula/1/exercicio/1", user_id: 1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_rankings)
  end

  test "should create user_ranking" do
    post :create, user_ranking: { path: @user_ranking.path, points: @user_ranking.points, user_id: @user_ranking.user_id }
    #p "===+> body: #{@response.body}"
    assert_response :created
  end

  test "should show user_ranking" do
    get :show, id: @user_ranking
    assert_response :success
  end

end
