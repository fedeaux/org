class CreateTatTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :tat_targets do |t|
      t.float :start
      t.float :duration
      t.string :type
      t.string :identifier
      t.references :tat, foreign_key: true

      t.timestamps
    end
  end
end
