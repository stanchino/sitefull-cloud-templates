class Account < ActiveRecord::Base
  belongs_to :organization

  has_many :credentials, dependent: :destroy
  has_many :providers, through: :credentials

  has_many :accounts_users, dependent: :destroy
  has_many :users, through: :accounts_users
end
