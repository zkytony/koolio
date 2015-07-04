require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "presence of attributes - nickname, email, password, activated" do
    @bob = User.new
    assert_not @bob.valid?
    @bob.nickname = "littlebob"
    assert_not @bob.valid?
    @bob.email = "bob@example.com"
    assert_not @bob.valid?
    @bob.password = "password"
    assert_not @bob.valid?
    @bob.activated = true
    assert @bob.valid?
  end

  test "uniqueness of nickname" do

  end
end
