class CreateInspections < ActiveRecord::Migration[6.1]
  def change
    create_table :inspections do |t|
      t.integer :score
      t.datetime :date
      t.string :inspection_type
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
