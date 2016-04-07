class AddPublicKeyToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :encrypted_public_key, :text
    add_column :deployments, :encrypted_public_key_salt, :string
    add_column :deployments, :encrypted_public_key_iv, :string
  end
end
