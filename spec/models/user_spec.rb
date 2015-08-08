require "rails_helper"
require "spec_helper"

RSpec.describe User, :type => :model do

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it do
    should allow_value("example@example.com", "examp.le@example.com").for(:email)
    should_not allow_value("onlystring", "\].@example.com", "@example.com", ".@.", "abc@abc").for(:email)
  end
  it { should validate_length_of(:email).is_at_most(255) }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6) } # greater_than(6) is minimum of 6

  it "should have non-empty password" do 
    user = User.new(username: "user1", email: "user1@example.com",
                    password: " " * 6, password_confirmation: " " * 6)
    expect(user.valid?).to be false
  end

  it "should validate that activated is defaulted to false" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                   password: "123456", password_confirmation: "123456")    
    expect(ben.activated).to be false
    ben.destroy
  end

  it { should have_many(:cards) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:decks) }
  it { should have_many(:decks).dependent(:destroy) }

  it { should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy) }
  it { should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy) }
  it { should have_many(:following).through(:active_relationships).source(:followed) }
  it { should have_many(:followers).through(:passive_relationships) }

  it "should follow another user" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                   password: "123456", password_confirmation: "123456")
    lily = User.create!(username: "lily", email: "lily@example.com",
                    password: "123456", password_confirmation: "123456")
    ben.follow(lily)
    expect(ben.following.count).to be(1)
    expect(ben.following?(lily)).to be true
    expect(lily.followers.count).to be(1)
    lily.follow(ben)
    expect(lily.following.count).to be(1)
    expect(lily.following?(ben)).to be true
    expect(ben.followers.count).to be(1)

    ben.destroy
    lily.destroy
  end

  it "should unfollow the other user" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                   password: "123456", password_confirmation: "123456")
    lily = User.create!(username: "lily", email: "lily@example.com",
                    password: "123456", password_confirmation: "123456")
    ben.follow(lily)
    expect(ben.following.count).to be(1)
    expect(lily.followers.count).to be(1)
    ben.unfollow(lily)
    expect(ben.following.count).to be(0)
    expect(lily.followers.count).to be(0)
  end

  it "should not be able to follow twice" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                   password: "123456", password_confirmation: "123456")
    lily = User.create!(username: "lily", email: "lily@example.com",
                    password: "123456", password_confirmation: "123456")
    ben.follow(lily)
    expect(ben.following.count).to be(1)
    expect {
      ben.follow(lily)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
