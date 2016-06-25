class Category < ActiveRecord::Base
  validates :name, presence: true,
                   length: { minimum: 1, maximum: 255 },
                   uniqueness: true
  validates :subdomain, presence: true,
                        length: { minimum: 1, maximum: 255 }

  has_many :categorizations
  has_many :decks, :through => :categorizations
  
  def all_names
    names = []
    self.all.each do |category|
      category.name >> names
    end
    names
  end
end
