require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user attributes must not be empty" do
    u = User.new
    assert u.invalid?
    assert u.errors[:username].any?
    assert u.errors[:email].any?
    assert u.errors[:password].any?
  end

  test "user email must be in correct format" do
    u = users(:invalidUser)
    u.email = "thisisnotavalidemailaddress.com"
    assert u.invalid?
    assert u.errors[:username].empty?
    assert u.errors[:email].any?
    u.email = "thisisavalidemailaddress@email.com"
    assert u.valid?
    assert u.errors[:email].empty?
  end

  test "username must be in correct format" do
    u = users(:validUser)
    assert u.valid?
    u.username = "Frank Miller!"
    assert u.invalid?
    assert u.errors[:username].any?
    u.username = "frankmiller"
    assert u.valid?
    assert u.errors[:username].empty?
  end

  test "should not allow creating a user with identical email" do
    u1 = users(:validUser)
    assert u1.valid?
    u2 = User.new({
      username: "secondary_user",
      email: "valid@user.com",
      password: "ienaidfhena"
      })
    assert u2.invalid?
    assert u2.errors[:email].any?
  end

  test "should not allow creating a user with identical username" do
    u1 = users(:validUser)
    assert u1.valid?
    u2 = User.new({
      username: "valid_user",
      email: "secondary@email.com",
      password: "ienaidfhena"
      })
    assert u2.invalid?
    assert u2.errors[:username].any?
  end

  test "should not allow creating a user with a username of a taken email" do
    u1 = users(:validUser)
    u2 = User.new({
      username: "valid@user.com",
      email: "user2@test.com",
      password: "bc123adsf"
      })
    assert u1.valid?
    assert u2.invalid?
    assert u2.errors[:username].any?
  end

  test "should vote for a restaurant" do
    user = users(:validUser)
    r1 = restaurants(:one)
    r2 = restaurants(:two)
    user.vote_for(r1, "will")
    assert_equal 1, user.votes.size
    user.vote_for(r2, "wont")
    assert_equal 2, user.votes.size
  end

  test "should not allow voting for the same restaurant twice" do
    user = users(:validUser)
    r1 = restaurants(:one)
    user.vote_for(r1, "will")
    assert_equal 1, user.votes.size
    user.vote_for(r1, "wont")
    assert_equal 1, user.votes.size
  end

  test "should check if user has voted" do
    user = users(:validUser)
    r = restaurants(:two)
    assert_equal false, user.has_voted_for?(r)
    user.vote_for(r, "will")
    assert user.has_voted_for?(r)
  end

  test "should favorite a restaurant" do
    user = users(:validUser)
    r1 = restaurants(:one)
    assert_equal false, user.has_favorited?(r1)
    user.favorite(r1)
    assert_equal 1, user.favorites.size
  end

  test "should unfavorite the same restaurant" do
    user = users(:validUser)
    r1 = restaurants(:one)
    assert_equal false, user.has_favorited?(r1)
    user.favorite(r1)
    assert_equal 1, user.favorites.size
    assert user.has_favorited?(r1)
    user.favorite(r1)
    assert_equal false, user.has_favorited?(r1)
    assert_equal 0, user.favorites.size
  end

  test "should check if user has favorited" do
    user = users(:validUser)
    r = restaurants(:two)
    assert_equal false, user.has_favorited?(r)
    user.favorite(r)
    assert user.has_favorited?(r)
  end

end
