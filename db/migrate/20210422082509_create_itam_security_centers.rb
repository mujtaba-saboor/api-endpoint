class CreateItamSecurityCenters < ActiveRecord::Migration[6.0]
  def change
    create_table :securitycenter do |t|
      t.string :scv
      t.string :category
      t.string :company
      t.string :product
      t.string :version
      t.integer :enabled
      t.integer :uptodate
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
