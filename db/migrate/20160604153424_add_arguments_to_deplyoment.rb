class AddArgumentsToDeplyoment < ActiveRecord::Migration
  def change
    enable_extension :hstore
    add_column :deployments, :arguments, :hstore
    add_index :deployments, :arguments, using: :gin
  end
end
