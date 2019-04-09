require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:validUser)
    @restaurant = restaurants(:unique)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
    assert_select 'table tbody tr', 10
    assert_select 'h2', 'SplitTheCheck'
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    sign_in @user
    @restaurant.name = "Something different"
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address} }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should not allow creating if not signed in" do
    post restaurants_url, params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address} }
    assert_redirected_to new_user_session_path
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 1
    assert_select 'div#voting_buttons', 1
    assert_select 'div#voting_buttons a', 2
  end

  test "should get edit" do
    sign_in @user
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    sign_in @user
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address, will_split: @restaurant.will_split, wont_split: @restaurant.wont_split } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should not allow editing if not signed in" do
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address, will_split: @restaurant.will_split, wont_split: @restaurant.wont_split } }
    assert_redirected_to new_user_session_path
  end

  test "can't destroy restaurant" do
    assert_raises(ActionController::RoutingError) do
      delete restaurant_url(@restaurant)
    end
  end

  test "should return search results" do
    get restaurants_url(params: { search: "American" })
    assert_response :success
    assert_equal "American", session[:search]
    assert_equal 1, session[:page]
    assert_equal 3, session[:total_pages]
    assert_select 'tr', 10
  end

  test "should vote and add to votes array" do
    sign_in @user
    get restaurant_url(@restaurant)
    assert_equal 0, session[:votes].count
    assert_equal 0, @restaurant.will_split
    put vote_restaurant_path(@restaurant), params: { split: "will_split" }
    assert_equal 1, session[:votes].count
  end

  test "should not allow voting if not signed in" do
    put vote_restaurant_path(@restaurant), params: { split: "will_split" }
    assert_redirected_to new_user_session_path
  end

  test "should clear the search term and page" do
    get clear_path
    assert_redirected_to root_path
    assert session[:search].nil?
    assert_equal 1, session[:page]
  end

  test "should redirect on RecordNotFound" do
    get restaurant_url(123125132)
    assert_redirected_to root_path
  end

  # Starts on page 1, confirms redirect and 10 restaurants, except page 4 which has 3
  test "should navigate to each page from page 1 up to 4" do
    get root_path
    assert_equal 4, session[:total_pages]
    1.upto(3) do |page|
      get page_path(page)
      assert_response :redirect
      assert_equal session[:page], page
      get root_path
      assert_select 'table tbody tr', minimum: 10
    end
    get page_path(4)
    assert_response :redirect
    assert_equal 4, session[:page]
    get root_path
    assert_select 'table tbody tr', minimum: 2
  end

  # Starts on page 4, confirms redirect and restaurants
  test "should navigate to each page from page 4 down to 1" do
    get root_path
    assert_equal 4, session[:total_pages]
    get page_path(11)
    assert_response :redirect
    assert_equal 4, session[:page]
    get root_path
    assert_select 'table tbody tr', minimum: 2
    3.downto(1) do |page|
      get page_path(page)
      assert_response :redirect
      assert_equal page, session[:page]
      get root_path
      assert_select 'table tbody tr', minimum: 10
    end
  end

  test "should not navigate to pages beyond the total page range" do
    get root_path
    get page_path(15)
    assert_response :redirect
    assert_equal 4, session[:page] #Max page
    get page_path(12)
    assert_response :redirect
    assert_equal 4, session[:page] #Max page
    get page_path(0)
    assert_response :redirect
    assert_equal 1, session[:page]  #Min page
    get page_path(-3)
    assert_response :redirect
    assert_equal 1, session[:page]  #Min page
  end
end
