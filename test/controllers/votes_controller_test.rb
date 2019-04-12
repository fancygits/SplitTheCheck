require 'test_helper'

class VotesControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:validUser)
    @vote = votes(:one)
  end

  test "should not get index" do
    get '/votes'
    assert_redirected_to root_url
  end

  test "should not get new" do
    get '/votes/new'
    assert_redirected_to root_url
  end

end
