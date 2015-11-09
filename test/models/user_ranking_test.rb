require 'test_helper'

class UserRankingTest < ActiveSupport::TestCase
  
  # test "the truth" do
  #   assert true
  # end

  setup do
    @user_ranking = UserRanking.find_by(path: "aula/1/exercicio/1", user_id: 1)
    @set = {:aula => {1 => {:exercicio => [1,2], :video => [1,2]}, 2 => {:exercicio => [1,2]}}}
    Path.destroy_all
    path = Path.create(structure: @set)
  end

  test "should append points to a ranking sucessfully" do
  	user_ranking = UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 10)
  	assert user_ranking.errors.empty?
  	assert_equal user_ranking.points, 10

  	user_ranking = UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 5)
  	assert user_ranking.errors.empty?
  	assert_equal user_ranking.points, 5

    parent_ranking = UserRanking.find_in_path(path: "aula/1", user_id: 1)
    assert_equal parent_ranking.points, 5

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

  test "should mark parent as done" do
    UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 10)
    UserRanking.create_or_append(path: "aula/1/exercicio/1", user_id: @user_ranking.user_id, points: 10)

    UserRanking.create_or_append(path: "aula/1/video/1", user_id: @user_ranking.user_id, points: 10)
    UserRanking.create_or_append(path: "aula/1/video/2", user_id: @user_ranking.user_id, points: 10)

    #sleep 0.5

    parent_user = User.find_by(user_id: 1)
    #assert_equal parent_user.points, 41
    assert_equal parent_user.score[:exercicio], 2        
    assert_equal parent_user.score[:video], 2 
    assert_equal parent_user.score[:aula], 1

  end

  test "should not mark parent as done" do
    UserRanking.create_or_append(path: "aula/1/exercicio/2", user_id: @user_ranking.user_id, points: 10)

    parent_user = User.find_by(user_id: 1)
    assert_equal parent_user.points, 11
    assert_equal parent_user.score[:exercicio], 1  
    assert_not  parent_user.score[:aula]
    assert_not  parent_user.score[:video]

  end


end
