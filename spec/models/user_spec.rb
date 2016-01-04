require "rails_helper"
require "spec_helper"

RSpec.describe User, :type => :model do

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_length_of(:username).is_at_most(20) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it do
    should allow_value("example@example.com", "examp.le@example.com").for(:email)
    should_not allow_value("onlystring", "\].@example.com", "@example.com", ".@.", "abc@abc").for(:email)
  end
  it { should validate_length_of(:email).is_at_most(255) }

  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6) } # greater_than(6) is minimum of 6

  it { should have_many(:cards) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:decks) }
  it { should have_many(:decks).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:active_relationships).class_name("Relationship").with_foreign_key("follower_id").dependent(:destroy) }
  it { should have_many(:passive_relationships).class_name("Relationship").with_foreign_key("followed_id").dependent(:destroy) }
  it { should have_many(:following).through(:active_relationships).source(:followed) }
  it { should have_many(:followers).through(:passive_relationships) }

  it { should have_many(:favor_of_decks).class_name("Favorite").dependent(:destroy) }
  it { should have_many(:favorite_decks).through(:favor_of_decks).source(:deck) }

  it { should have_many(:like_of_cards).class_name("LikeCard").dependent(:destroy) }
  it { should have_many(:liked_cards).through(:like_of_cards).source(:card) }

  it { should have_many(:deck_user_associations).dependent(:destroy) }
  it { should have_many(:deck_editor_associations).dependent(:destroy) }
  it { should have_many(:deck_viewer_associations).dependent(:destroy) }
  it { should have_many(:editable_decks).through(:deck_editor_associations).source(:deck) }
  it { should have_many(:decks_shared_for_view).through(:deck_viewer_associations).source(:deck) }

  it { should have_many(:active_recommendations).class_name("Recommendation").with_foreign_key("from_user_id").dependent(:destroy) }
  it { should have_many(:passive_recommendations).class_name("Recommendation").with_foreign_key("to_user_id").dependent(:destroy) }
  it { should have_many(:recommendings_of_cards).through(:active_recommendations) }
  it { should have_many(:recommendings_of_decks).through(:active_recommendations) }
  it { should have_many(:recommended_cards).through(:passive_recommendations) }
  it { should have_many(:recommended_decks).through(:passive_recommendations) }

  it { should have_many(:activities).dependent(:destroy) }
  
  it { should have_many(:uploaded_files) }

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

  it "should update attributes of a user without needing password" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                       password: "123456", password_confirmation: "123456")    
    ben[:username] = "ben2"
    ben.save!
    new_ben = User.find(ben.id)
    expect(new_ben.username).to eq "ben2"
  end

  it "should update the password" do
    ben = User.create!(username: "ben", email: "ben@example.com",
                       password: "123456", password_confirmation: "123456")    
    #ben[:password] = "1234567"
    ben.password = "1234567"
    ben.password_confirmation = "1234567"
    ben.save!
    new_ben = User.authenticate("ben", "1234567")
    expect(new_ben.id).to eq ben.id
  end

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

  it "should authenticate user with email and password" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    user_get = User.authenticate(user.email, user.password)
    expect(user_get).not_to be false
    expect(user_get.username).to eq("user1")
  end

  it "should authenticate user with username and password" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    user_get = User.authenticate(user.username, user.password)
    expect(user_get).not_to be false
    expect(user_get.username).to eq("user1")
  end

  it "should not authenticate user with email or username and wrong password" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    expect(User.authenticate(user.email, "not the password")).to be false
    expect(User.authenticate(user.username, "not the password")).to be false
  end

  it "should not authenticate user with wrong email or username and password" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    expect(User.authenticate("bad email", user.password)).to be false
    expect(User.authenticate("bad username", user.password)).to be false
  end

  it "should favorite deck" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    user.favor_deck(deck)
    expect(user.favorite_decks.count).to be 1
    expect(user.favoring_deck?(deck)).to be true
  end

  it "should unfavor deck" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    user.favor_deck(deck)
    expect(user.favorite_decks.count).to be 1
    user.unfavor_deck(deck)
    expect(user.favorite_decks.count).to be 0
  end

  it "should not favor a deck twice" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    user.favor_deck(deck)
    expect(user.favorite_decks.count).to be 1
    expect {
      user.favor_deck(deck)
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should like a card" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    user.like_card(card)
    expect(user.liked_cards.count).to be 1
    expect(card.liked_users.count).to be 1
    expect(card.likes).to be 1
  end

  it "should unlike a card" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    user.like_card(card)
    expect(user.liked_cards.count).to be 1
    expect(card.liked_users.count).to be 1
    expect(card.likes).to eq 1
    user.unlike_card(card)
    expect(user.liked_cards.count).to be 0
    expect(card.liked_users.count).to be 0
    expect(card.likes).to eq 0
  end

  it "should not like a card twice" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    user.like_card(card)
    expect(user.liked_cards.count).to be 1
    expect(card.liked_users.count).to be 1
    expect {
      user.like_card(card)
      expect(card.likes).to eq 1
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should not unlike a card that has not been liked" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    user.unlike_card(card)
    expect(user.liked_cards.count).to be 0
    expect(card.liked_users.count).to be 0
    expect(card.likes).to eq 0
  end

  it "should comment on card" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    message1 = "Hello! How are you!"
    comment1 = user.comment(card, message1)
    message2 = "I like your card!"
    comment2 = user.comment(card, message2)
    expect(user.comments.count).to be 2
    expect(card.comments.count).to be 2
    expect(comment1.content).to eq message1
    expect(comment2.content).to eq message2
  end

  it "should like a comment" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    message = "Hello! How are you!"
    comment = user.comment(card, message)
    user.like_comment(comment)
    expect(user.liked_comments.count).to be 1
    expect(comment.liked_users.count).to be 1
    expect(comment.likes).to be 1
  end

  it "should unlike a comment" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    message = "Hello! How are you!"
    comment = user.comment(card, message)
    user.like_comment(comment)
    expect(user.liked_comments.count).to be 1
    expect(comment.liked_users.count).to be 1
    expect(comment.likes).to be 1
    user.unlike_comment(comment)
    expect(user.liked_comments.count).to be 0
    expect(comment.liked_users.count).to be 0
    expect(comment.likes).to be 0
  end

  it "should not like a comment twice" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, user)
    card.save!
    message = "Hello! How are you!"
    comment = user.comment(card, message)
    user.like_comment(comment)
    expect(user.liked_comments.count).to be 1
    expect(comment.liked_users.count).to be 1
    expect {
      user.like_comment(comment)
      expect(comment.likes).to eq 1
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should create a deck, and see himself added as editor" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    expect(deck.editors.count).to be 1
    expect(deck.editors.include?(user)).to be true
  end

  it "should be able to turn down a share" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.share_to(userB, "Viewer")
    expect(deck.viewable_by?(userB)).to be true
    userB.turndown_deck_share(deck)
    expect(deck.viewable_by?(userB)).to be false
  end

  it "should be able to recommend a deck or card to a user, and cancel these recommendations" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!

    userA.recommend_to(userB, deck)
    expect(userA.recommendings_of_decks.count).to be 1
    expect(userB.recommended_decks.count).to be 1

    userA.recommend_to(userB, card)
    expect(userA.recommendings_of_cards.count).to be 1
    expect(userB.recommended_cards.count).to be 1

    userA.cancel_recommendation(userB, deck)
    expect(userA.recommendings_of_decks.count).to be 0
    expect(userB.recommended_decks.count).to be 0

    userA.cancel_recommendation(userB, card)
    expect(userA.recommendings_of_cards.count).to be 0
    expect(userB.recommended_cards.count).to be 0
  end

  it "should be able to turn down recommendation of deck and card" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!

    userA.recommend_to(userB, deck)
    userA.recommend_to(userB, card)
    
    userB.turndown_recommendation(userA, deck)
    expect(userA.recommendings_of_decks.count).to be 0
    expect(userB.recommended_decks.count).to be 0
    userB.turndown_recommendation(userA, card)
    expect(userA.recommendings_of_cards.count).to be 0
    expect(userB.recommended_cards.count).to be 0
  end

  it "should inspect avatar" do
    user = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    
    expect(user.my_avatar!("front")).to eq "/assets/default-profile.svg"
    expect(user.my_avatar!("back")).to eq "/assets/default-profile.svg"
  end

  it "should return list of mutually followed users of given user" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    userC = User.create(username: "userC", email: "userC@example.com",
                        password: "123456", password_confirmation: "123456")
    userD = User.create(username: "userD", email: "userD@example.com",
                        password: "123456", password_confirmation: "123456")    
    userA.follow(userB)
    userA.follow(userC)
    userA.follow(userD)
    
    userB.follow(userA)
    userC.follow(userA)
    userD.follow(userA)
    
    mutuals = userA.mutual_follows
    expect(mutuals.length).to be 3
    expect(mutuals.include?(userB)).to be true
    expect(mutuals.include?(userC)).to be true
    expect(mutuals.include?(userD)).to be true
  end
end
