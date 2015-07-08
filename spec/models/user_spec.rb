require "rails_helper"
require "spec_helper"

RSpec.describe User, :type => :model do
  it "validates that username must be present" do
    david = User.new(email: "david@example.com",
                     password: "123456",
                     activated: true)
    expect(david.valid?).to be(false)
    david.username = "david"
    expect(david.valid?).to be(true)
  end

  it "validates that email must be present" do
    david = User.new(username: "david",
                     password: "123456",
                     activated: true)
    expect(david.valid?).to be(false)
    david.email = "david@example.com"
    expect(david.valid?).to be(true)
  end

  it "validates that password must be present" do
    david = User.new(username: "david",
                     email: "david@example.com",
                     activated: true)
    expect(david.valid?).to be(false)
    david.password = "123456"
    expect(david.valid?).to be(true)
  end

  it "validates that activated has default value false" do
    david = User.new(username: "david",
                     email: "david@example.com",
                     password: "123456")
    expect(david.valid?).to be(true)
    expect(david.activated).to be(false)
  end
end
