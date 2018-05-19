class CreateLoggables < ActiveRecord::Migration[5.2]
  def change
    create_table :loggables do |t|
      t.string :text_color
      t.string :background_color
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
