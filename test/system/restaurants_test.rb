require "application_system_test_case"

class RestaurantsTest < ApplicationSystemTestCase
  setup do
    @restaurant = restaurants(:magic)
  end

  test "visiting the index" do
    visit restaurants_url
    assert_selector "h2", text: "SplitTheCheck"
  end

  test "creating a Restaurant" do
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
    click_on "Back"
  end

  test "updating a Restaurant" do
    visit restaurants_url
    click_on "Abacadabra"
    click_on "Edit"

    fill_in "City", with: "Updated City"
    fill_in "Cuisine", with: "Pizza"
    fill_in "Name", with: @restaurant.name
    fill_in "Postcode", with: 12354
    fill_in "State", with: "MT"
    fill_in "Street address", with: "999 Tampopo Dr"
    click_on "Update Restaurant"

    assert_text "Restaurant was successfully updated"
    click_on "Back"
  end

  # test "voting for a Restaurant" do
  #   visit restaurants_url
  #   fill_in "Restaurant name or city", with: "azkaban"
  #   click_on "Search"
  #   assert_text "Abracadabra"
  #   find("#will_split_button").click
  #   expect(restaurants_url).not_to have_selector("#will_split_button")
  #   expect(restaurants_url).to have_selector("#will_split_disabled")
  # end

  test "search for a restaurant" do
    visit restaurants_url
    fill_in "Restaurant name or city", with: "unique"
    click_on "Search"
    assert_text "Unique New York"
  end
end
