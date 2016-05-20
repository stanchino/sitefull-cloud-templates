class AddAccountsUserToDeployments < ActiveRecord::Migration
  def change
    add_reference :deployments, :accounts_user, index: true, foreign_key: true
  end
end
