require "rails_helper"
require "spec_helper"

RSpec.describe User, :type => :model do

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_format_of(:email)
      .to_allow("example@example.com")
      .not_to_allow("onlystring")
      .not_to_allow("\].@example.com")
      .not_to_allow("@example.com")
      .not_to_allow(".@.")
      .not_to_allow("abc@abc")
  }
  it { is_expected.to validate_length_of(:email).less_than(255) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).greater_than(6) } # greater_than(6) is minimum of 6

  it { is_expected.to validate_presence_of(:activated) }

  it "should have non-empty password" do 
    user = User.new(username: "user1", email: "user1@example.com",
                    password: " " * 6, password_confirmation: " " * 6)
    expect(user.valid?).to be false
  end

  it { is_expected.to have_many(:cards).with_foreign_key(:user_id) }
  it { is_expected.to have_many(:cards).with_dependent(:delete) }
  it { is_expected.to have_many(:decks).with_foreign_key(:user_id) }
  it { is_expected.to have_many(:decks).with_dependent(:delete) }
  it { is_expected.to have_many(:comments).with_foreign_key(:user_id) }
  it { is_expected.to have_many(:comments).with_dependent(:delete) }

  it "should authenticate user with email and password" do
    user = User.new(username: "user1", email: "user1@example.com",
                    password: "123456", password_confirmation: "123456")
    user_get = User.authenticate(user.email, user.password)
    expect(user_get).not_to be_nil
    expect(user_get.username).to eq("user1")
  end

  it "should authenticate user with username and password" do
    user = User.new(username: "user1", email: "user1@example.com",
                    password: "123456", password_confirmation: "123456")
    user_get = User.authenticate(user.username, user.password)
    expect(user_get).not_to be_nil
    expect(user_get.username).to eq("user1")
  end

  it "should not authenticate user with email or username and wrong password" do
    user = User.new(username: "user1", email: "user1@example.com",
                    password: "123456", password_confirmation: "123456")
    expect(User.authenticate(user.email, "not the password")).to be false
    expect(User.authenticate(user.username, "not the password")).to be false
  end

  it "should not authenticate user with wrong email or username and password" do
    user = User.new(username: "user1", email: "user1@example.com",
                    password: "123456", password_confirmation: "123456")
    expect(User.authenticate("bad email", user.password)).to be false
    expect(User.authenticate("bad username", user.password)).to be false
  end
end
