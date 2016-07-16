# frozen_string_literal: true
class AccountsUser < ActiveRecord::Base
  belongs_to :account
  belongs_to :user
  has_many :deployments, dependent: :destroy

  delegate :organization_id, to: :account
end
