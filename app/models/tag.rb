class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  
  has_and_belongs_to_many :decks, dependent: :destroy
  
  private

    def tag_params
      params.require(:tag).permit(:name, :deck_id)
    end
end
