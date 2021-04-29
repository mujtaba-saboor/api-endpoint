class CreateTableBios < ActiveRecord::Migration[6.0]
  def change
    create_table :bios do |t|
      t.string :smanufacturer
      t.string :smodel
      t.string :ssn
      t.string :type
      t.string :bmanufacturer
      t.string :bversion
      t.string :bdate
      t.string :assettag
      t.string :mmanufacturer
      t.string :mmodel
      t.string :msn
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
