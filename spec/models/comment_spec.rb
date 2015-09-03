require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:card_id) }
  it { should validate_presence_of(:content) }
  it { should belong_to(:user) }
  it { should belong_to(:card) }
end
