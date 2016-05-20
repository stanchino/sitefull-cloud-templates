class AddProviderToDeployments < ActiveRecord::Migration
  def change
    add_reference :deployments, :provider, index: true, foreign_key: true
  end
end
