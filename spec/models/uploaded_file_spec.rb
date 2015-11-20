require 'rails_helper'

RSpec.describe UploadedFile, type: :model do
  it { should validate_presence_of(:user_id) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:type) }
  it { should validate_length_of(:type).is_at_most(255) }

  it { should belong_to(:user) }
end
