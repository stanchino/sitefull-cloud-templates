class AddErrorToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :error, :text
  end
end
