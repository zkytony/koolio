require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:subdomain) }
  it { should validate_length_of(:subdomain).is_at_most(255) }
  it { should validate_length_of(:subdomain).is_at_least(1) }
  it do
    should allow_value("abc", "34oZ44a").for(:subdomain)
    should_not allow_value("d dsf", "sdf\tcool", "$#@*({:\"%").for(:subdomain)
  end

  it { should belong_to(:user) }
  it { should have_many(:cards) }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_and_belong_to_many(:tags) }
  it { should have_one(:categories).through(:categorization) }

  it { should have_many(:users_with_favor).class_name("Favorite").dependent(:destroy) }
  it { should have_many(:favoring_users).through(:users_with_favor).source(:user) }

  it { should have_many(:deck_user_associations).dependent(:destroy) }
  it { should have_many(:deck_editor_associations).dependent(:destroy) }
  it { should have_many(:deck_viewer_associations).dependent(:destroy) }
  it { should have_many(:shared_users).through(:deck_user_associations).source(:user) }
  it { should have_many(:editors).through(:deck_editor_associations).source(:user) }
  it { should have_many(:normal_viewers).through(:deck_viewer_associations).source(:user) }

  it { should have_many(:recommendations) }
  it { should have_many(:activities) }

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
    deck.add_tag({name: "test"})
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
    # deck is not open
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.share_to(userB, "Viewer")
    expect(deck.editors.count).to be 1     # including userA himself
    expect(deck.normal_viewers.count).to be 1
    expect(deck.shared_users.count).to be 2
  end

  it "should change type of share" do
    # deck is not open
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
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

  it "should not change the share role of the creator" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    expect(deck.creator? userA).to be true
    expect(deck.change_share_role(userA, "Viewer")).to be false
  end

  it "should avoid duplicating shares" do 
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.share_to(userB, "Viewer")
    expect(deck.viewable_by?(userB)).to be true
    expect(deck.normal_viewers.count).to be 1
    # share to the same person again. Should not duplicate the association
    deck.share_to(userB, "Viewer")
    expect(deck.normal_viewers.count).to be 1
  end

  it "should just share when calling change role but there is no association" do
    userA = User.create(username: "userA", email: "userA@example.com",
                       password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                       password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    # userB is not shared. But change_share_role should share it.
    deck.change_share_role(userB, "Editor")
    expect(deck.editors.count).to be 2
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

  it "should delete the deck even it has cards & tags and it is shared" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)    
    deck.add_tag({name: "tag1"})
    deck.share_to(userB, "Editor")
    
    deck.destroy
    expect(userA.decks.count).to be 0
    expect(Card.all.count).to be 0
    expect(userA.editable_decks.count).to be 0
  end

  it "should update the tags_names attribute of the deck when added a new tag" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.add_tag({name: "hey"})
    expect(deck.tags_names).to eq "hey"
    deck.add_tag({name: "haha"})
    expect(deck.tags_names).to eq "hey haha"
  end

  it "should not duplicate tags in tags_names" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)
    deck.add_tag({name: "hey"})
    deck.add_tag({name: "haha"})
    deck.add_tag({name: "hey"})
    deck.add_tag({name: "hey"})
    tag = Tag.find_or_create_by({name: "hey"})
    expect(deck.tags.include? tag).to be true
    expect(deck.tags_names).to eq "hey haha"
  end

  it "should be able to add multiple tags using the add_tags method" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456")
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description", open: false)    
    tags = [{name: "hey"}, {name: "haha"}, {name: "lol"}]
    deck.add_tags(tags)
    expect(deck.tags.count).to be 3
    expect(deck.tags_names).to eq "hey haha lol"
  end
end
