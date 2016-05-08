class AddCurrentAccountToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :current_account, index: true, references: :accounts
  end
end
