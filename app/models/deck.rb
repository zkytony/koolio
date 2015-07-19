class Deck
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,      type: String
  field :title,        type: String
  field :description,  type: String
  field :cards,        type: Array, default: []
  field :tags,         type: Array, default: []

  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 255 }

  belongs_to :user,  dependent: :nullify
  has_many :cards,   dependent: :delete

end
