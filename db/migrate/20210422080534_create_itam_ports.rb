class CreateItamPorts < ActiveRecord::Migration[6.0]
  def change
    create_table :ports do |t|
      t.string :type
      t.string :name
      t.string :caption
      t.string :description
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
