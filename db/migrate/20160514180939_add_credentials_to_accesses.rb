class AddCredentialsToAccesses < ActiveRecord::Migration
  def up
    enable_extension :hstore
    add_column :accesses, :credentials, :hstore
    add_index :accesses, :credentials, using: :gin
  end

  def down
    #remove_column :accesses, :credentials
    #remove_index :accesses, :credentials
    #disable_extension :hstore
  end
end
