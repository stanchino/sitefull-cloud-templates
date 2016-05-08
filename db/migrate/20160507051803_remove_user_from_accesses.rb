class RemoveUserFromAccesses < ActiveRecord::Migration
  def change
    remove_reference :accesses, :user, index: true, foreign_key: true
  end
end
