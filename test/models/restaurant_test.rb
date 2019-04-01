require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
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

end
