class RemoveStatusFromDeployments < ActiveRecord::Migration
  def change
    remove_column :deployments, :status
  end
end
