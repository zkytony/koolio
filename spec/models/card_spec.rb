require 'rails_helper'

RSpec.describe Card, type: :model do

  it { is_expected.to validate_presence_of(:deck_id) }
  it { is_expected.to validate_presence_of(:user_id) }

  it { is_expected.to belong_to(:deck).of_type(Deck) }
  it { is_expected.to belong_to(:user).of_type(User) }
  it { is_expected.to have_many(:comments).with_foreign_key(:card_id) }
  it { is_expected.to have_many(:comments).with_dependent(:delete) }

end
