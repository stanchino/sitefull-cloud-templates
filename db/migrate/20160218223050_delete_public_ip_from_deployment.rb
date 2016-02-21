class DeletePublicIpFromDeployment < ActiveRecord::Migration
  def up
    remove_column :deployments, :public_ip
  end

  def down
    add_column :deployments, :public_ip, :inet
  end
end
