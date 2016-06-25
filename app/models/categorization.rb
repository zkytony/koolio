class Categorization < ActiveRecord::Base
  validates :category_id, presence: true
  validates :deck_id, presence: true
  
  belongs_to :category
  belongs_to :deck
end
