class Deck
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,        type: String
  field :description,  type: String
  field :cards,        type: Array, default: []
  field :tags,         type: Array, default: []

  validates :title, presence: true,
                    length: { maximum: 255 }

end
