class Template < ActiveRecord::Base
  acts_as_taggable
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user
end
