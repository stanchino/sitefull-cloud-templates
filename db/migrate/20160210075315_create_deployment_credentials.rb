class CreateDeploymentCredentials < ActiveRecord::Migration
  def change
    create_table :deployment_credentials do |t|
      t.references :credential, index: true, foreign_key: true
    end
  end
end
