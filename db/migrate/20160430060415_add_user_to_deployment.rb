class AddUserToDeployment < ActiveRecord::Migration
  def change
    add_reference :deployments, :user, index: true, foreign_key: true
  end
end
