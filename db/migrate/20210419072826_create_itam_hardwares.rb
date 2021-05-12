class CreateItamHardwares < ActiveRecord::Migration[6.0]
  def change
    create_table :hardware do |t|
      t.string :deviceid
      t.string :name
      t.string :workgroup
      t.string :userdomain
      t.string :osname
      t.string :osversion
      t.string :oscomments
      t.text :processort
      t.integer :processors
      t.integer :processorn, limit: 2
      t.integer :memory
      t.integer :swap
      t.string :ipaddr
      t.string :dns
      t.string :defaultgateway
      t.datetime :etime
      t.datetime :lastdate
      t.datetime :lastcome
      t.decimal :quality, precision: 7, scale: 4
      t.bigint :fidelity
      t.string :userid
      t.integer :type
      t.string :description
      t.string :wincompany
      t.string :winowner
      t.string :winprodid
      t.string :winprodkey
      t.string :useragent, limit: 50
      t.bigint :checksum, unsigned: true
      t.integer :sstate
      t.string :ipsrc
      t.string :uuid
      t.string :arch, limit: 10
      t.integer :itam_hardware_id
      t.boolean :components_updated_during_sync, default: false
      t.integer :category_id
      t.string :resource_id
      t.string :device_type

      t.timestamps
    end
  end
end
