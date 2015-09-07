require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(175) }

  it { should belong_to(:user) }
  it { should have_many(:cards) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_and_belong_to_many(:tags) }

  it { should have_many(:users_with_favor).class_name("Favorite").dependent(:destroy) }
  it { should have_many(:favoring_users).through(:users_with_favor).source(:user) }

  it { should have_many(:deck_user_associations).dependent(:destroy) }
  it { should have_many(:deck_editor_associations).dependent(:destroy) }
  it { should have_many(:deck_viewer_associations).dependent(:destroy) }
  it { should have_many(:shared_users).through(:deck_user_associations).source(:user) }
  it { should have_many(:editors).through(:deck_editor_associations).source(:user) }
  it { should have_many(:normal_viewers).through(:deck_viewer_associations).source(:user) }

  it { should have_many(:recommendations) }

  it "should add tag" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    tag = deck.add_tag({name: "test"})
    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
    tag2 = deck.add_tag({name: "test2"})
    expect(deck.tags.count).to be 2
    expect(tag2.decks.count).to be 1
  end

  it "should not add duplicate tags with same name" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    tag = deck.add_tag({name: "test"})
    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
    expect {
      deck.add_tag({name: "test"})      
    }.to raise_error(ActiveRecord::RecordNotUnique)

    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
  end

  it "should remove tag" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    tag = deck.add_tag({name: "test"})
    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
    deck.remove_tag(tag)
    expect(deck.tags.count).to be 0
    expect(tag.decks.count).to be 0
  end

  it "should remove all tags (association-wise)" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.create_deck(title: "Testing deck", description: "Testing deck description")
    deck.add_tag({name: "test1"})
    deck.add_tag({name: "test2"})
    deck.add_tag({name: "test3"})
    expect(deck.tags.count).to be 3
    deck.remove_all_tags
    expect(deck.tags.count).to be 0
    deck.add_tag({name: "test1"})
    expect(deck.tags.count).to be 1
  end

  it "should share a deck to another user as editor" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description")
    deck.share_to(userB, "Editor")
    expect(deck.editors.count).to be 2     # including userA himself
    expect(deck.normal_viewers.count).to be 0
    expect(deck.shared_users.count).to be 2
  end

  it "should share a deck to another user as viewer" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description")
    deck.share_to(userB, "Viewer")
    expect(deck.editors.count).to be 1     # including userA himself
    expect(deck.normal_viewers.count).to be 1
    expect(deck.shared_users.count).to be 2
  end

  it "should change type of share" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description")
    deck.share_to(userB, "Viewer")
    expect(deck.editable_by?(userB)).to be false
    deck.change_share_role(userB, "Editor")
    expect(deck.editable_by?(userB)).to be true
    expect(deck.editors.count).to be 2     # including userA himself
  end

  it "should unshare deck" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.share_to(userB, "Viewer")
    expect(deck.viewable_by?(userB)).to be true
    deck.unshare(userB)
    expect(deck.viewable_by?(userB)).to be false
  end

  it "should recognize who it is recommended to and by" do
        userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!

    userA.recommend_to(userB, card)
    expect(card.is_recommended_by?(userA)).to be true
    expect(card.is_recommended_to?(userB)).to be true
  end
end
