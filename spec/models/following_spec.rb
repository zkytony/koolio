require 'rails_helper'

RSpec.describe Following, type: :model do

  it { is_expected.to validate_presence_of(:username) }  
  it { is_expected.to be_embedded_in(:user) }

end
