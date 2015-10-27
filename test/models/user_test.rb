require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
  	#@user = users(:one)
  end

  test "should create a user sucessfully" do
  	user = User.create(user_id: 3, points: 0, name: "test")
  	assert user.errors.empty?
  end
end
