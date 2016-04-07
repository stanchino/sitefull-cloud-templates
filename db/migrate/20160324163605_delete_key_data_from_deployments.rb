class DeleteKeyDataFromDeployments < ActiveRecord::Migration
  def change
    remove_column :deployments, :encrypted_key_data
    remove_column :deployments, :encrypted_key_data_salt
    remove_column :deployments, :encrypted_key_data_iv
  end
end
