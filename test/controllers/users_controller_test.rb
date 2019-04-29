require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:validUser)
    @restaurant = restaurants(:unique)
  end

  test "should get user profile" do
    sign_in @user
    get profile_url
    assert_response :success
  end

  test "should not get user profile if not logged in" do
    get profile_url
    assert_response :redirect
    assert_redirected_to root_path
  end

end
