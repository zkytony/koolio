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

  it "should add tag" do
    user = User.create(username: "user1", email: "user1@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = user.decks.create(title: "Testing deck", description: "Testing deck description")
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
    deck = user.decks.create(title: "Testing deck", description: "Testing deck description")
    tag = deck.add_tag({name: "test"})
    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
    tag2 = deck.add_tag({name: "test"})
    expect(deck.tags.count).to be 1
    expect(tag.decks.count).to be 1
  end
end
