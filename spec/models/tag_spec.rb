require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should have_and_belong_to_many(:decks) }
end
