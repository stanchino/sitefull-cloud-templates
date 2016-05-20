class RemoveCredentialsFromDeployments < ActiveRecord::Migration
  def up
    remove_column :deployments, :credentials
    disable_extension :hstore
  end

  def down
    enable_extension :hstore
    add_column :deployments, :credentials, :hstore
  end
end
