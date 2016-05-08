class AccountsUser < ActiveRecord::Base
  belongs_to :account
  belongs_to :user
  has_many :deployments, dependent: :destroy
end
