class Deployment < ActiveRecord::Base
  belongs_to :template

  validates :provider, presence: true
  validates :image, presence: true
  validates :flavor, presence: true
end
