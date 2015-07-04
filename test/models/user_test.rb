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
    @david2 = User.new(nickname: "mrDavid",
                       email: "david2@example.com",
                       password: "password",
                       activated: true)
    assert_not @david2.valid?
  end

  test "uniqueness of email" do
    @david2 = User.new(nickname: "mrDavid2",
                       email: "david@example.com",
                       password: "password",
                       activated: true)
    assert_not @david2.valid?
  end

end
