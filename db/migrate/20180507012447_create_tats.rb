class CreateTats < ActiveRecord::Migration[5.2]
  def change
    create_table :tats do |t|

      t.timestamps
    end
  end
end
