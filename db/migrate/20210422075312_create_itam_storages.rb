class CreateItamStorages < ActiveRecord::Migration[6.0]
  def change
    create_table :storages do |t|
      t.string :manufacturer
      t.string :name
      t.string :model
      t.string :description
      t.string :type
      t.integer :disksize
      t.string :serialnumber
      t.string :firmware
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
