class AddOrganizationIdToProviders < ActiveRecord::Migration
  def change
    add_reference :providers, :organization, index: true, foreign_key: true
  end
end
