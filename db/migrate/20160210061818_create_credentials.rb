class CreateCredentials < ActiveRecord::Migration
  def up
    enable_extension :hstore
    create_table :credentials do |t|
      t.string :type
      t.hstore :credentials
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    disable_extension :hstore
    drop_table :credentials
  end
end
