class CreateItamAccountInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :accountinfo do |t|
      t.string :access_token, null: false
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
