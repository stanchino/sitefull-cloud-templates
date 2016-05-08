class Account < ActiveRecord::Base
  belongs_to :organization
  has_many :accesses, dependent: :destroy
  has_many :accounts_users, dependent: :destroy
  has_many :providers, through: :accesses
  has_many :users, through: :accounts_users
end
