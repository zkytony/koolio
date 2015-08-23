require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(175) }

  it { should belong_to(:user) }
  it { should have_many(:cards) }
  it { should have_many(:cards).dependent(:destroy) }

  it { should have_many(:favoring_users).class_name("Favorite").dependent(:destroy) }
end
