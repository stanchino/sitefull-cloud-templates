class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.references :provider, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :encrypted_token
      t.string :encrypted_token_salt
      t.string :encrypted_token_iv

      t.timestamps null: false
    end
  end
end
