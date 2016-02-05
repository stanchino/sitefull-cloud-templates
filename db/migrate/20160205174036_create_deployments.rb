class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.references :template, index: true
      t.string :provider, index: true
      t.json :credentials
      t.string :image, index: true
      t.string :flavor

      t.timestamps null: false
    end
  end
end
