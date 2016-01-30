class Template < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :os, presence: true

  belongs_to :user
end
