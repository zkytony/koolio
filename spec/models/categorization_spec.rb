require 'rails_helper'

RSpec.describe Categorization, type: :model do
  it { should validate_presence_of(:deck_id) }
  it { should validate_presence_of(:category_id) }

  it { should belong_to(:deck) }
  it { should belong_to(:category) }
end
