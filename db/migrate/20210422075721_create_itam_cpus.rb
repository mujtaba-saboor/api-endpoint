class CreateItamCpus < ActiveRecord::Migration[6.0]
  def change
    create_table :cpus do |t|
      t.string :manufacturer
      t.string :type
      t.string :serialnumber
      t.string :speed
      t.integer :cores
      t.string :l2cachesize
      t.string :cpuarch
      t.integer :data_width
      t.integer :current_address_width
      t.integer :logical_cpus
      t.string :voltage
      t.string :current_speed
      t.string :socket
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
