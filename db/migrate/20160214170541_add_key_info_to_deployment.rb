class AddKeyInfoToDeployment < ActiveRecord::Migration
  def change
    add_column :deployments, :key_name, :string
    add_column :deployments, :encrypted_key_data, :string
    add_column :deployments, :encrypted_key_data_salt, :string
    add_column :deployments, :encrypted_key_data_iv, :string
  end
end
