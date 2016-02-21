class RemoveNotNullConstraintsFromDeployment < ActiveRecord::Migration
  def change
    change_column :deployments, :region, :string, null: false, default: ''
    change_column :deployments, :flavor, :string, null: false, default: ''
  end
end
