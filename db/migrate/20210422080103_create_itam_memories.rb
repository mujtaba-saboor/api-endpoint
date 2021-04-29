class CreateItamMemories < ActiveRecord::Migration[6.0]
  def change
    create_table :memories do |t|
      t.string :caption
      t.string :description
      t.string :capacity
      t.string :purpose
      t.string :type
      t.string :speed
      t.integer :numslots, limit: 2
      t.string :serialnumber
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
