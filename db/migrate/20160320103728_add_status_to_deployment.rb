class AddStatusToDeployment < ActiveRecord::Migration
  def change
    add_column :deployments, :status, :string
  end
end
