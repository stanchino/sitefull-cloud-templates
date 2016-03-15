class CreateProviderSettings < ActiveRecord::Migration
  def change
    create_table :provider_settings do |t|
      t.string :name
      t.string :encrypted_value
      t.string :encrypted_value_salt
      t.string :encrypted_value_iv
      t.references :provider, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
