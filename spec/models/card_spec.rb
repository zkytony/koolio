require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should validate_presence_of(:deck_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:subdomain) }
  it { should validate_length_of(:subdomain).is_at_most(255) }
  it { should validate_length_of(:subdomain).is_at_least(1) }
  it do
    should allow_value("abc", "34oZ44a").for(:subdomain)
    should_not allow_value("d dsf", "sdf\tcool", "$#@*({:\"%").for(:subdomain)
  end

  it { should belong_to(:deck) }
  it { should belong_to(:user) }

  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:users_with_like).class_name("LikeCard").dependent(:destroy) }
  it { should have_many(:liked_users).through(:users_with_like).source(:user) }

  it { should have_many(:recommendations) }
  it { should have_many(:activities).dependent(:destroy) }

  it "should not be viewed once hidden" do
    userA = User.create(username: "userA", email: "userA@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    userB = User.create(username: "userB", email: "userB@example.com",
                        password: "123456", password_confirmation: "123456", activated: true)
    deck = userA.create_deck(title: "Testing deck", description: "Testing deck description")
    card = deck.build_card({front_content: "Hi", back_content: "Bye"}, userA)
    card.save!

    # Deck is Open, so card should be viewable
    expect(card.viewable_by?(userB)).to be true
    card.update(hide: true)
    # After hiding, card should not be viewable
    expect(card.viewable_by?(userB)).to be false
  end
end
