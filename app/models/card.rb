class Card
  include Mongoid::Document
  incldue Mongoid::Timestamp

  field :deck_id,       type: String
  field :user_id,       type: String
  field :front_content, type: Text
  field :back_content,  type: Text
  field :flips,         type: Integer, default: 0
  field :comments,      type: Array,   default: []

  validates :deck_id, presence: true
  validates :user_id, presence: true
  
  belongs_to :deck,    dependent: :nullify
  belongs_to :user,    dependent: :nullify
  has_many :comments,  dependent: :delete
  
end
