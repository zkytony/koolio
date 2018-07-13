require 'rails_helper'

RSpec.describe Notification, type: :model do
  it "should handle notifications with User as notifier" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    userA.follow(userB)
    
    userB.notifications.create(action: "FollowedByUser", notifier: userA)
    expect(userB.notifications.count).to be 1
  end

  it "should handle notifications with DeckUserAssociation as notifier" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")

    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    share = deck.share_to(userB, "Editor")
    userB.notifications.create(action: "ShareDeck", notifier: share)
    expect(userB.notifications.count).to be 1

    share_obtained = userB.notifications.find_by(action: "ShareDeck").notifier
    expect(share_obtained.type).to eq "DeckEditorAssociation"
  end

  it "should handle notifications with Recommendation as notifier" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")    
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    recommend = userA.recommend_to(userB, deck)
    userB.notifications.create(action: "RecommendTo", notifier: recommend)
    expect(userB.notifications.count).to be 1

    recommend_obtained = userB.notifications.find_by(action: "RecommendTo").notifier
    expect(recommend_obtained.recommendable_type).to eq "Deck"
  end

  it "should handle notifications with Favorite as notifier" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")    
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)    
    favorite = userB.favor_deck(deck)
    userA.notifications.create(action: "FavoriteDeck", notifier: favorite)
    expect(userA.notifications.count).to be 1

    favorite_obtained = userA.notifications.find_by(action: "FavoriteDeck").notifier
    expect(favorite_obtained.deck.id).to be deck.id
  end

  it "should handle notifications with LikeCard as notifier" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!
    like = userB.like_card(card)
    userA.notifications.create(action: "LikeCard", notifier: like)
    expect(userA.notifications.count).to be 1

    like_obtained = userA.notifications.find_by(action: "LikeCard").notifier
    expect(like_obtained.card.id).to be card.id    
  end
end
