require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "presence of attributes - username, email, password, activated" do
    @bob = User.new
    assert_not @bob.valid?
    @bob.username = "littlebob"
    assert_not @bob.valid?
    @bob.email = "bob@example.com"
    assert_not @bob.valid?
    @bob.password = "password"
    assert_not @bob.valid?
    @bob.activated = true
    assert @bob.valid?
  end

  test "uniqueness of username" do
    @david2 = User.new(username: "mrDavid",
                       email: "david2@example.com",
                       password: "password",
                       activated: true)
    assert_not @david2.valid?
  end

  test "uniqueness of email" do
    @david2 = User.new(username: "mrDavid2",
                       email: "david@example.com",
                       password: "password",
                       activated: true)
    assert_not @david2.valid?
  end

end
