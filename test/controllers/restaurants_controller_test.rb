require 'test_helper'

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:unique)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
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
end
