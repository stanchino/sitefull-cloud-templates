class CreateAccountsUsers < ActiveRecord::Migration
  def change
    create_table :accounts_users do |t|
      t.references :account, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
