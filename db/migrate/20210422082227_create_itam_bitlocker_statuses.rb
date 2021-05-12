class CreateItamBitlockerStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :bitlockerstatus do |t|
      t.string :drive
      t.string :volumetype
      t.string :conversionstatus
      t.string :protectionstatus
      t.string :encrypmethod
      t.string :initprotect
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
