class AddValidatorToTemplateArgument < ActiveRecord::Migration
  def change
    add_column :template_arguments, :validator, :string
  end
end
