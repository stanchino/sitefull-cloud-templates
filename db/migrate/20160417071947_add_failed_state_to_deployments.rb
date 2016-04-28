class AddFailedStateToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :failed_state, :string
  end
end
