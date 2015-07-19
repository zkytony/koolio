class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,      type: String
  field :card_id,      type: String
  field :content,      type: String
  field :likes,        type: Integer

  validates :user_id, presence: true
  validates :card_id, presence: true
  validates :content, presence: true

  belongs_to :card,  dependent: :nullify
  belongs_to :user,  dependent: :nullify

end
