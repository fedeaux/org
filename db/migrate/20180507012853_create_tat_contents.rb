class CreateTatContents < ActiveRecord::Migration[5.2]
  def change
    create_table :tat_contents do |t|
      t.jsonb :properties, default: {}
      t.string :content
      t.string :content_type
      t.references :tat, foreign_key: true

      t.timestamps
    end
  end
end
