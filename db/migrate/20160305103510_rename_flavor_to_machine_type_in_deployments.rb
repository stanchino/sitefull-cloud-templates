class RenameFlavorToMachineTypeInDeployments < ActiveRecord::Migration
  def change
    rename_column :deployments, :flavor, :machine_type
  end
end
