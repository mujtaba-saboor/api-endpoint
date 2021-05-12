class CreateItamPrinters < ActiveRecord::Migration[6.0]
  def change
    create_table :printers do |t|
      t.string :name
      t.string :driver
      t.string :port
      t.string :description
      t.string :servername
      t.string :sharename
      t.string :resolution, limit: 50
      t.string :comment
      t.integer :shared
      t.integer :network
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
