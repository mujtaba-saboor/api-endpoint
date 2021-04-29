class CreateTableDrive < ActiveRecord::Migration[6.0]
  def change
    create_table :drives do |t|
      t.string :letter
      t.string :type
      t.string :filesystem
      t.bigint :total
      t.bigint :free
      t.integer :numfiles
      t.string :volumn
      t.datetime :createdate
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
