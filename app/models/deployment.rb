class Deployment < ActiveRecord::Base
  PROVIDERS = %w(aws google azure).freeze

  belongs_to :template

  validates :provider, presence: true, inclusion: PROVIDERS
  validates :image, presence: true
  validates :flavor, presence: true
end
