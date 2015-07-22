require 'rails_helper'

RSpec.describe Following, type: :model do

  it { is_expected.to validate_presence_of(:followee) }  
  it { is_expected.to validate_presence_of(:follower) }
end
