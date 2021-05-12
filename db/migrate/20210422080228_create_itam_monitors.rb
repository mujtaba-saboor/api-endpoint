class CreateItamMonitors < ActiveRecord::Migration[6.0]
  def change
    create_table :monitors do |t|
      t.string :manufacturer
      t.string :caption
      t.string :description
      t.string :type
      t.string :serial
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
