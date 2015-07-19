require 'rails_helper'

RSpec.describe Deck, type: :model do

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).less_than(255) }

  it { is_expected.to belong_to(:user).of_type(User) }
  it { is_expected.to have_many(:cards).with_foreign_key(:deck_id) }
  it { is_expected.to have_many(:cards).with_dependent(:delete) }

end
