class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :script
      t.references :user

      t.timestamps null: false
    end

    add_index :templates, :name
    add_index :templates, :user_id
  end
end
