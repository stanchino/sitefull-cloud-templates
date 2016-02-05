class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name, index: true
      t.text :script
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
