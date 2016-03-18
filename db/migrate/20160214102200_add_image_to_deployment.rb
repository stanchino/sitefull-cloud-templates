class AddImageToDeployment < ActiveRecord::Migration
  def change
    add_column :deployments, :image, :string, null: false, default: ''
  end
end
