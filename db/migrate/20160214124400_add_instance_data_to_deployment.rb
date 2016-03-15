class AddInstanceDataToDeployment < ActiveRecord::Migration
  def change
    add_column :deployments, :network_id, :string
    add_column :deployments, :instance_id, :string
  end
end
