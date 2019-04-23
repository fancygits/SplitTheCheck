require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
# Test Validation
  test "restaurant attributes must not be empty" do
    r = Restaurant.new
    assert r.invalid?
    assert r.errors[:name].any?
    assert r.errors[:cuisine].any?
    assert r.errors[:street_address].any?
    assert r.errors[:city].any?
    assert r.errors[:state].any?
    assert r.errors[:postcode].any?
  end

  test "restaurant state must be capital letters" do
    r = restaurants(:two)
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "Il"
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "78"
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "IL"
    assert r.valid?
  end

  test "restaurant state must be 2 characters long" do
    r = restaurants(:one)
    assert r.valid?
    r.state = "Illinois"
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "ILLINOIS"
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "I"
    assert r.invalid?
    assert r.errors[:state].any?
    r.state = "IL"
    assert r.valid?
  end

  test "restaurant names must be unique" do
    r = restaurants(:one)
    assert r.valid?
    r.name = "Unique New York"
    assert r.invalid?
    assert r.errors[:name].any?
  end

# Test Search Functionality
  test "search returns a restaurant" do
    r = Restaurant.search("Unique")
    assert r.count > 0
  end

  test "search returns lots of restaurants" do
    r = Restaurant.search("New Restaurant")
    assert r.count > 0
    assert_equal 30, r.count
  end

  test "search finds restaurant names" do
    r = Restaurant.search("Unique New York")
    assert r.count == 1
    assert_equal "Unique New York", r.first.name
  end

  test "search finds restaurant cuisine" do
    restaurants = Restaurant.search("American")
    assert_equal 30, restaurants.count
    restaurants.each do |restaurant|
      assert_equal "American", restaurant.cuisine
    end
  end

  test "search finds restaurant city" do
    r = Restaurant.search("Falsevi")
    assert_equal 1, r.count
    assert_equal "Falseville", r.first.city
  end

  test "search finds restaurant state" do
    r = Restaurant.search("ky")
    assert_equal 1, r.count
    assert_equal "KY", r.first.state
  end

  test "search finds restaurant postcode" do
    restaurants = Restaurant.search("90210")
    assert_equal 30, restaurants.count
    restaurants.each do |restaurant|
      assert_equal "90210", restaurant.postcode
    end
  end

  test "search uses wildcards before and after terms" do
    r = Restaurant.search("e")
    assert_equal 33, r.count
  end

  test "search throws a StandardError on no results" do
    err = assert_raises(StandardError) do
      r = Restaurant.search("ZZYZX")
    end
    assert_equal "Searching for \"ZZYZX\" yielded no results.", err.message
  end

end
