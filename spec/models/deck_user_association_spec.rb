require 'rails_helper'

RSpec.describe DeckUserAssociation, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:deck_id) }

  it { should belong_to(:user) }
  it { should belong_to(:deck) }
end
