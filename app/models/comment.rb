class Comment < ActiveRecord::Base
  validates :user_id, presence: true
  validates :card_id, presence: true
  validates :content, presence: true

  belongs_to :user
  belongs_to :card

  has_many :activities, as: :trackable, dependent: :destroy
end
