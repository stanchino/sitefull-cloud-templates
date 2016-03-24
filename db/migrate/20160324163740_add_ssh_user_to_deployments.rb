class AddSshUserToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :ssh_user, :string
  end
end
