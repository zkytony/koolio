class Deck < ActiveRecord::Base

  field :user_id,      type: String
  field :title,        type: String
  field :description,  type: String
  field :tags,         type: Array, default: []

  validates :user_id, presence: true
  validates :title, presence: true,
                    length: { maximum: 255 }

  belongs_to :user,  dependent: :nullify
  has_many :cards,   dependent: :delete
  has_many :subscriptions, dependent: :delete

end
