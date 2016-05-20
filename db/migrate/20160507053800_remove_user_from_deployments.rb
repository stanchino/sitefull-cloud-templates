class RemoveUserFromDeployments < ActiveRecord::Migration
  def change
    remove_reference :deployments, :user, index: true, foreign_key: true
  end
end
