class RenameAccessesToCredentials < ActiveRecord::Migration
  def change
    rename_table :accesses, :credentials
  end
end
