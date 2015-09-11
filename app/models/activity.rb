class Activity < ActiveRecord::Base
  validates_presence_of :user_id, :action, :trackable_type, :trackable_id

  belongs_to :user
  belongs_to :trackable, polymorphic: true
end
