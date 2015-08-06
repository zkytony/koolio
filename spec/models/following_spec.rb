require 'rails_helper'

RSpec.describe Following, type: :model do
  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followee_id) }
  it { should belong_to(:follower).class_name("User") }
  it { should belong_to(:followee).class_name("User") }
end
