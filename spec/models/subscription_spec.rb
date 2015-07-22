require 'rails_helper'

RSpec.describe Subscription, type: :model do

  it { is_expected.to validate_presence_of(:subscriber) }  
  it { is_expected.to validate_presence_of(:deck_id) }
  it { is_expected.to validate_presence_of(:created_at) }
  it { is_expected.to belong_to(:deck).of_type(Deck) }
end
