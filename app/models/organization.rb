class Organization < ActiveRecord::Base
  has_many :providers
  has_many :accounts

  validates :name, uniqueness: true, presence: true
end
