class AddPrivateKeyToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :encrypted_private_key, :text
    add_column :deployments, :encrypted_private_key_salt, :string
    add_column :deployments, :encrypted_private_key_iv, :string
  end
end
