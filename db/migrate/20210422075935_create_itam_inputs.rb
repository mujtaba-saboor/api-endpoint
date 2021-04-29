class CreateItamInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :inputs do |t|
      t.string :type
      t.string :manufacturer
      t.string :caption
      t.string :description
      t.string :interface
      t.string :pointtype
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
      