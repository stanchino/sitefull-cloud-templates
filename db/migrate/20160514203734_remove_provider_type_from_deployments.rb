class RemoveProviderTypeFromDeployments < ActiveRecord::Migration
  def change
    remove_column :deployments, :provider_type, :string
  end
end
