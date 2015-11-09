require 'test_helper'

class UserRankingsIntegrationTest < ActionDispatch::IntegrationTest

  include AssertJson

  setup do
    @user_ranking = UserRanking.find_by(path: "aula/1/exercicio/1", user_id: 1)
  end

  test "should get existent path index" do
    get "/aula/1/exercicio/1"
    assert_response :success
    assert assigns(:user_rankings)
  end

  test "should validate inexistent path index" do
    get "/aula/5/exercicio/2"
    assert_equal @response.body, "[]"
  end

  test "should create a path index" do
  	post "/aula/1/exercicio/2", user_ranking: {points: 1, user_id: 1}
  	assert_response :created
  	
  	get "/aula/1/exercicio/2"
  	assert_response :ok
  	assert_json(@response.body) do
      item 0 do
      	has 'user_id', 1
        has 'points', 1
      end
    end

	 get "/aula/1"
  	assert_response :ok
  	assert_json(@response.body) do
      item 0 do
      	has 'user_id', 1
        has 'points', 1
      end
    end
  end

  test "should validate path format status" do
  	post "/aula/1/hey", user_ranking: {points: 40, user_id: 1}
  	assert_response :unprocessable_entity
  end

  test "should ordenate users on a path" do
  	
  	10.times do |time|
  		post "/aula/1/exercicio/2", user_ranking: {points: time + 1, user_id: time + 1}
      #p "================> #{@response.body}"
  		assert_response :created
  	end

  	get "/aula/1/exercicio/2"
	  assert_response :ok
  	assert_json(@response.body) do
  	  value = 10
  	  10.times do |time|
  	  	item time do
	      	has 'user_id', value
			    has 'points', value
	      	value-=1
	      end
  	  end
    end  	

  end

  test "should validate params on create index" do
    post "/aula/1/exercicio/2", user_ranking: {points: 10}
    assert_response :unprocessable_entity
  end

  test "should paginate ranking results" do
    10.times do |time|
      post "/aula/1/exercicio/2", user_ranking: {points: time + 1, user_id: time + 1}
      p "===========> body: #{@response.body}"
      assert_response :created
    end

    value = 10
    10.times do |time|
      get "/aula/1/exercicio/2?limit=1&offset=#{time}"
      assert_json(@response.body) do
        item 0 do
          has 'user_id', value
          has 'points', value
          value-=1
        end
      end
    end


  end


end
