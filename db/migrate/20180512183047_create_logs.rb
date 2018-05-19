class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.datetime :start
      t.datetime :finish
      t.references :loggable, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
