require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
  	@user = User.find_by(name: "user_one")
  end

  test "should create a user sucessfully" do
  	user = User.create(user_id: 3, points: 0, name: "test")
  	assert user.errors.empty?
  end

  test "should validate uniqueness of user id" do
  	user = User.create(user_id: @user.user_id, points: 0, name: "test")
  	assert_equal user.errors.full_messages.first, "User is already taken"
  end

  test "should validate presence of user_id" do
  	user = User.create
  	messages = user.errors.full_messages
  	assert messages.include?("User can't be blank")
  end
end
