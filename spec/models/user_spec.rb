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

  it { should validate_presence_of(:activated) }

  it { should have_many(:cards).with_foreign_key(:user_id) }
  it { should have_many(:cards).with_dependent(:destroy) }
  it { should have_many(:decks).with_foreign_key(:user_id) }
  it { should have_many(:decks).with_dependent(:destroy) }
  it { should have_many(:comments).with_foreign_key(:user_id) }
  it { should have_many(:comments).with_dependent(:destroy) }
end
