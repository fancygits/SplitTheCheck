require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:validUser)
    @comment = comments(:one)
  end

  test "should get index" do
    get comments_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_comment_url
    assert_response :success
  end

  test "should create comment" do
    sign_in @user
    assert_difference('Comment.count') do
      post comments_url, params: { comment: { body: @comment.body, restaurant_id: @comment.restaurant_id, user_id: @comment.user_id } }
    end

    assert_redirected_to comment_url(Comment.last)
  end

  test "should show comment" do
    get comment_url(@comment)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get edit_comment_url(@comment)
    assert_response :success
  end

  test "should update comment" do
    sign_in @user
    patch comment_url(@comment), params: { comment: { body: @comment.body, restaurant_id: @comment.restaurant_id, user_id: @comment.user_id } }
    assert_redirected_to comment_url(@comment)
  end

  test "should destroy comment" do
    sign_in @user
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to comments_url
  end
end
