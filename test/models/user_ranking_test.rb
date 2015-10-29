require 'test_helper'

class UserRankingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user_ranking = UserRanking.find_by(path: "aula/1/exercicio/1", user_id: 1)
  end

  test "should append points to a ranking sucessfully" do
  	user_ranking = UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 10)
  	assert user_ranking.errors.empty?
  	assert_equal user_ranking.points, 10

  	user_ranking = UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 5)
  	assert user_ranking.errors.empty?
  	assert_equal user_ranking.points, 15

    parent_ranking = UserRanking.find_by(path: "aula/1", user_id: 1)
    assert_equal parent_ranking.points, 18

    parent_user = User.find_by(user_id: 1)
    assert_equal parent_user.points, 16
    assert_equal parent_user.score[:exercicio], 1

    user_ranking = UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 5)
  
    parent_user = User.find_by(user_id: 1)
    assert_equal parent_user.points, 21
    assert_equal parent_user.score[:exercicio], 1    

  end

  test "should validate presence of fields" do
    assert_raises(ValidationException) {user_ranking = UserRanking.create_or_append(nil)}
    assert_raises(ValidationException) {user_ranking = UserRanking.create_or_append(path: "aula/1")}
    assert_raises(ValidationException) {user_ranking = UserRanking.create_or_append(path: "aula/1", user_id: 1)}
    assert_raises(ValidationException) {user_ranking = UserRanking.create_or_append(path: "aula/1", points: 1)}
  end

end
