class Organization < ActiveRecord::Base
  has_many :providers

  validates :name, uniqueness: true, presence: true
end
