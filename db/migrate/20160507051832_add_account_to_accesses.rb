class AddAccountToAccesses < ActiveRecord::Migration
  def change
    add_reference :accesses, :account, index: true, foreign_key: true
  end
end
