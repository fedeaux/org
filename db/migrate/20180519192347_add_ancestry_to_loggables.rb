class AddAncestryToLoggables < ActiveRecord::Migration[5.2]
  def change
    add_column :loggables, :ancestry, :string
    add_index :loggables, :ancestry
  end
end
