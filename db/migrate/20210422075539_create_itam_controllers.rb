class CreateItamControllers < ActiveRecord::Migration[6.0]
  def change
    create_table :controllers do |t|
      t.string :manufacturer
      t.string :name
      t.string :caption
      t.string :description
      t.string :version
      t.string :type
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
