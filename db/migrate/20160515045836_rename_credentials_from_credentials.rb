class RenameCredentialsFromCredentials < ActiveRecord::Migration
  def change
    rename_column :credentials, :credentials, :data
  end
end
