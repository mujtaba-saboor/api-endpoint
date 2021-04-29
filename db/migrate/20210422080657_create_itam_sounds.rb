class CreateItamSounds < ActiveRecord::Migration[6.0]
  def change
    create_table :sounds do |t|
      t.string :manufacturer
      t.string :name
      t.string :description
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
