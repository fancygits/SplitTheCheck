require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase
  driven_by :selenium, using: :firefox

  include Warden::Test::Helpers

  setup do
    @restaurant = restaurants(:magic)
    @user = users(:validUser)
  end

  test "visiting the index" do
    visit restaurants_url
    assert_selector "h2", text: "SplitTheCheck"
  end

  test "user is directed to sign in page before creating a restaurant" do
    visit restaurants_url
    click_on "Add a Restaurant"
    assert_selector "h4", text: "Alert"
    assert_text "You need to sign in or sign up before continuing."
  end

  test "creating a Restaurant" do
    login_as @user
    visit restaurants_url
    click_on "Add a Restaurant"
    fill_in "City", with: @restaurant.city
    fill_in "Cuisine", with: @restaurant.cuisine
    fill_in "Name", with: "Original Restaurant Name"
    fill_in "Postcode", with: @restaurant.postcode
    fill_in "State", with: @restaurant.state
    fill_in "Street address", with: @restaurant.street_address
    click_on "Create Restaurant"
    assert_text "Restaurant was successfully created"
    assert_text "Original Restaurant Name"
    Warden.test_reset!
  end

  test "updating a Restaurant" do
    login_as @user
    visit restaurants_url

    click_on "Abracadabra"
    click_on "Edit"

    fill_in "City", with: "Updated City"
    fill_in "Cuisine", with: "Pizza"
    fill_in "Name", with: @restaurant.name
    fill_in "Postcode", with: 12354
    fill_in "State", with: "MT"
    fill_in "Street address", with: "999 Tampopo Dr"
    click_on "Update Restaurant"

    assert_text "Restaurant was successfully updated"
    assert_text "Abracadabra"
    click_on "Home"
    Warden.test_reset!
  end

  test "voting for a Restaurant" do
    login_as @user
    visit restaurants_url
    fill_in "Restaurant name or city", with: @restaurant.name
    click_on "Search"
    assert_selector "tr", text: "Abracadabra", count: 1
    assert_selector "a", text: "0\nWill Split"
    click_on "Will Split"
    assert_selector "a", class: "disabled", text: "1\nWill Split"
    Warden.test_reset!
  end

  test "search for a restaurant" do
    visit restaurants_url
    fill_in "Restaurant name or city", with: "unique"
    click_on "Search"
    assert_text "Unique New York"
  end
end
