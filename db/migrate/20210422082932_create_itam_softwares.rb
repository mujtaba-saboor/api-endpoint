class CreateItamSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :softwares do |t|
      t.text :publisher
      t.string :name
      t.string :version
      t.text :folder
      t.text :comments
      t.string :filename
      t.integer :filesize
      t.integer :source
      t.string :guid
      t.string :language
      t.datetime :installdate
      t.integer :bitswidth
      t.text :description, size: :medium
      t.text :url
      t.string :software_type
      t.boolean :delta, default: true
      t.string :category
      t.string :app_extension
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end

      