require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:validUser)
    @restaurant = restaurants(:magic)
    @comment = comments(:two)
  end

  test "should get index" do
    get restaurant_path(@restaurant)
    assert_response :success
    assert_select 'h4', /Comment/
  end

  test "should get comments on a restaurant" do
    get restaurant_url(@restaurant)
    assert @restaurant.comments.present?
  end

  test "should create comment on a restaurant" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_difference('@user.comments.count') do
      post restaurant_comments_path(@restaurant), params: { comment: { body: @comment.body } }
    end
    assert_redirected_to restaurant_path(@restaurant)
    assert_equal 'Comment was successfully created.', flash[:notice]
  end

  test "should not allow commenting if not signed in" do
    post restaurant_comments_path(@restaurant), params: { comment: { body: @comment.body } }
    assert_redirected_to new_user_session_path
  end

  test "should destroy comment" do
    sign_in @user
    assert_difference('@user.comments.count', -1) do
      delete restaurant_comment_path(@restaurant, @comment)
    end
    assert_redirected_to restaurant_path(@restaurant)
    assert_equal 'Comment was successfully deleted.', flash[:notice]
  end

  test "should not destroy comment if not signed in" do
    delete restaurant_comment_path(@restaurant, @comment)
    assert_redirected_to new_user_session_path
  end
end
