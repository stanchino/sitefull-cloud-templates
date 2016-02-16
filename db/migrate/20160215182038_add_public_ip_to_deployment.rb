class AddPublicIpToDeployment < ActiveRecord::Migration
  def change
    add_column :deployments, :public_ip, :inet
  end
end
