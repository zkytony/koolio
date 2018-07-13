require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:trackable_type) }
  it { should validate_presence_of(:trackable_id) }
  it { should belong_to(:user) }
  it { should belong_to(:trackable) }

  it "should handle activities with Deck as trackable" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)

    create_deck_activity = userA.activities.create!(action: "CreateDeck", trackable: deck)
    update_deck_activity = userA.activities.create!(action: "UpdateDeck", trackable: deck)
    favorite_deck_activity = userA.activities.create!(action: "FavoriteDeck", trackable: deck)

    expect(userA.activities.count).to be 3
    expect(deck.activities.count).to be 3
  end

  it "should handle activities with Card as trackable" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!
    
    create_deck_activity = userA.activities.create!(action: "CreateCard", trackable: card)
    update_deck_activity = userA.activities.create!(action: "UpdateCard", trackable: card)
    like_deck_activity = userA.activities.create!(action: "CreateCard", trackable: card)

    expect(userA.activities.count).to be 3
    expect(card.activities.count).to be 3
  end

  it "should handle activities with Card as trackable" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!
    message = "Hello! How are you!"
    comment = userA.comment(card, message)
    
    create_comment_activity = userA.activities.create(action: "CreateComment", trackable: comment)
    expect(userA.activities.count).to be 1
    expect(comment.activities.count).to be 1
  end

  it "should handle activities with User as trackable" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    userA.follow(userB)
    
    follow_activity = userA.activities.create(action: "FollowUser", trackable: userB)
    expect(userA.activities.count).to be 1
  end
  
end
