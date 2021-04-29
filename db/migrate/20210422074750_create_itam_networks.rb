class CreateItamNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :networks do |t|
      t.string :description
      t.string :type
      t.string :typemib
      t.string :speed
      t.string :mtu
      t.string :macaddr
      t.string :status
      t.string :ipaddress
      t.string :ipmask
      t.string :ipgateway
      t.string :ipsubnet
      t.string :ipdhcp
      t.boolean :virtualdev
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
