require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "user attributes must not be empty" do
    u = User.new
    assert u.invalid?
    assert u.errors[:username].any?
    assert u.errors[:email].any?
    assert u.errors[:password].any?
  end

end
