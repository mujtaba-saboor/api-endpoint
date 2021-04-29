class CreateItAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :api_asset_details do |t|
      t.string :name
      t.integer :group_id
      t.integer :sub_group_id
      t.integer :location_id
      t.datetime :purchased_on
      t.datetime :last_source_sync_date
      t.string :identifier
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
