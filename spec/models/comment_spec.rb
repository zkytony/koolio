require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:card_id) }
  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to belong_to(:user).of_type(User) }
  it { is_expected.to belong_to(:card).of_type(Card) }

end
