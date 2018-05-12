class AddUserToTat < ActiveRecord::Migration[5.2]
  def change
    add_reference :tats, :user, foreign_key: true
  end
end
