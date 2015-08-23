require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should validate_presence_of(:deck_id) }
  it { should validate_presence_of(:user_id) }

  it { should belong_to(:deck) }
  it { should belong_to(:user) }

  it { should have_many(:users_with_like).class_name("LikeCard").dependent(:destroy) }
  it { should have_many(:liked_users).through(:users_with_like).source(:user) }
end
