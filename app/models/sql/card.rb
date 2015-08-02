class Card < ActiveRecord::Base

  field :deck_id,       type: String
  field :user_id,       type: String
  field :front_content, type: String
  field :back_content,  type: String
  field :flips,         type: Integer, default: 0

  validates :deck_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :deck,    dependent: :nullify
  belongs_to :user,    dependent: :nullify
  has_many :comments,  dependent: :delete
  
end
