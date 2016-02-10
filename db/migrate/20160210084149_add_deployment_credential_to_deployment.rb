class AddDeploymentCredentialToDeployment < ActiveRecord::Migration
  def change
    add_reference :deployments, :deployment_credential, index: true, foreign_key: true
  end
end
