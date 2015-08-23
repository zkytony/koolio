require 'rails_helper'

RSpec.describe LikeCard, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:card_id) }
end
