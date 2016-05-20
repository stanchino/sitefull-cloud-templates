class AddConfiguredToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :configured, :boolean, index: true, default: false
  end
end
