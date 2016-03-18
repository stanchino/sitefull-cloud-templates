class CreateDeployments < ActiveRecord::Migration
  def up
    enable_extension :hstore
    create_table :deployments do |t|
      t.references :template, index: true
      t.hstore :credentials
      t.string :provider_type, null: false, index: true
      t.string :region, null: false
      t.string :flavor, null: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :deployments
    disable_extension :hstore
  end
end
