class CreateInspectionViolations < ActiveRecord::Migration[6.1]
  def change
    create_table :inspection_violations do |t|
      t.string :violation_type
      t.datetime :date
      t.text :description
      t.references :inspection, null: false, foreign_key: true
      t.references :risk_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
