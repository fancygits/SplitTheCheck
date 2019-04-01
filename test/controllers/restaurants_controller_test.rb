require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
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
    @restaurant.name = "Something different"
    assert_difference('Restaurant.count') do
      post restaurants_url, params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address} }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
    assert_select 'h1', 1
    assert_select 'div#voting_buttons', 1
    assert_select 'div#voting_buttons a', 2
  end

  test "should get edit" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), params: { restaurant: { city: @restaurant.city, cuisine: @restaurant.cuisine, name: @restaurant.name, postcode: @restaurant.postcode, state: @restaurant.state, street_address: @restaurant.street_address, will_split: @restaurant.will_split, wont_split: @restaurant.wont_split } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "can't destroy restaurant" do
    assert_raises(ActionController::RoutingError) do
      delete restaurant_url(@restaurant)
    end
  end

  # Starts on page 1, confirms redirect and 10 restaurants, except page 4 which has 3
  test "should navigate to each page from page 1 up to 4" do
    get root_path
    assert_equal session[:total_pages], 4
    1.upto(3) do |page|
      get page_path(page)
      assert_response :redirect
      assert_equal session[:page], page
      get root_path
      assert_select 'table tbody tr', minimum: 10
    end
    get page_path(4)
    assert_response :redirect
    assert_equal session[:page], 4
    get root_path
    assert_select 'table tbody tr', minimum: 2
  end

  # Starts on page 4, confirms redirect and restaurants
  test "should navigate to each page from page 4 down to 1" do
    get root_path
    assert_equal session[:total_pages], 4
    get page_path(11)
    assert_response :redirect
    assert_equal session[:page], 4
    get root_path
    assert_select 'table tbody tr', minimum: 2
    3.downto(1) do |page|
      get page_path(page)
      assert_response :redirect
      assert_equal session[:page], page
      get root_path
      assert_select 'table tbody tr', minimum: 10
    end
  end

  test "should not navigate to pages beyond the total page range" do
    get root_path
    get page_path(15)
    assert_response :redirect
    assert_equal session[:page], 4 #Max page
    get page_path(12)
    assert_response :redirect
    assert_equal session[:page], 4 #Max page
    get page_path(0)
    assert_response :redirect
    assert_equal session[:page], 1  #Min page
    get page_path(-3)
    assert_response :redirect
    assert_equal session[:page], 1  #Min page
  end
end
