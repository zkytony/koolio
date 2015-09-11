require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:trackable_type) }
  it { should validate_presence_of(:trackable_id) }
  it { should belong_to(:user) }
  it { should belong_to(:trackable) }

  it "should create an activity via user" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    activity = userA.activities.create!(action: "CreateDeck", trackable: deck)
    expect(userA.activities.count).to be 1
    expect(deck.activities.count).to be 1
  end
end
