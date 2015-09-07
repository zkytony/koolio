require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  it { should validate_presence_of(:from_user_id) }
  it { should validate_presence_of(:to_user_id) }
  it { should validate_presence_of(:recommendable_id) }
  it { should validate_presence_of(:recommendable_type) }

  it { should belong_to(:from_user).class_name("User") }
  it { should belong_to(:to_user).class_name("User") }
  it { should belong_to(:recommendable) }
end
