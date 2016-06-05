class CreateTemplateArguments < ActiveRecord::Migration
  def change
    create_table :template_arguments do |t|
      t.string :textkey, allow_nil: false
      t.string :name, allow_nil: false
      t.boolean :required, default: false
      t.string :default, allow_nil: true, default: nil
      t.references :template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
