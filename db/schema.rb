# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_26_124619) do

  create_table "accountinfo", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_token", null: false
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_accountinfo_on_hardware_id"
  end

  create_table "api_asset_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "group_id"
    t.integer "sub_group_id"
    t.integer "location_id"
    t.datetime "purchased_on"
    t.datetime "last_source_sync_date"
    t.string "identifier"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_api_asset_details_on_hardware_id"
  end

  create_table "api_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_token", null: false
    t.integer "itam_company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "merge_it_assets_on_uuid", default: false
    t.boolean "merge_it_assets_on_bios_serial", default: false
    t.boolean "merge_it_assets_on_mac_address", default: false
  end

  create_table "bios", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "smanufacturer"
    t.string "smodel"
    t.string "ssn"
    t.string "type"
    t.string "bmanufacturer"
    t.string "bversion"
    t.string "bdate"
    t.string "assettag"
    t.string "mmanufacturer"
    t.string "mmodel"
    t.string "msn"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_bios_on_hardware_id"
  end

  create_table "bitlockerstatus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "drive"
    t.string "volumetype"
    t.string "conversionstatus"
    t.string "protectionstatus"
    t.string "encrypmethod"
    t.string "initprotect"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_bitlockerstatus_on_hardware_id"
  end

  create_table "controllers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "manufacturer"
    t.string "name"
    t.string "caption"
    t.string "description"
    t.string "version"
    t.string "type"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_controllers_on_hardware_id"
  end

  create_table "cpus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "manufacturer"
    t.string "type"
    t.string "serialnumber"
    t.string "speed"
    t.integer "cores"
    t.string "l2cachesize"
    t.string "cpuarch"
    t.integer "data_width"
    t.integer "current_address_width"
    t.integer "logical_cpus"
    t.string "voltage"
    t.string "current_speed"
    t.string "socket"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_cpus_on_hardware_id"
  end

  create_table "drives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "letter"
    t.string "type"
    t.string "filesystem"
    t.bigint "total"
    t.bigint "free"
    t.integer "numfiles"
    t.string "volumn"
    t.datetime "createdate"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_drives_on_hardware_id"
  end

  create_table "hardware", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "deviceid"
    t.string "name"
    t.string "workgroup"
    t.string "userdomain"
    t.string "osname"
    t.string "osversion"
    t.string "oscomments"
    t.text "processort"
    t.integer "processors"
    t.integer "processorn", limit: 2
    t.integer "memory"
    t.integer "swap"
    t.string "ipaddr"
    t.string "dns"
    t.string "defaultgateway"
    t.datetime "etime"
    t.datetime "lastdate"
    t.datetime "lastcome"
    t.decimal "quality", precision: 7, scale: 4
    t.bigint "fidelity"
    t.string "userid"
    t.integer "type"
    t.string "description"
    t.string "wincompany"
    t.string "winowner"
    t.string "winprodid"
    t.string "winprodkey"
    t.string "useragent", limit: 50
    t.bigint "checksum", unsigned: true
    t.integer "sstate"
    t.string "ipsrc"
    t.string "uuid"
    t.string "arch", limit: 10
    t.integer "itam_hardware_id"
    t.boolean "components_updated_during_sync", default: false
    t.integer "category_id"
    t.string "resource_id"
    t.string "device_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.datetime "last_synced_with_main_instance"
  end

  create_table "inputs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "manufacturer"
    t.string "caption"
    t.string "description"
    t.string "interface"
    t.string "pointtype"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_inputs_on_hardware_id"
  end

  create_table "itam_mobile_device_securities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "jailbroken"
    t.boolean "encrypted"
    t.boolean "supervised"
    t.string "activation_lock_bypass_code"
    t.string "compliance_state"
    t.string "compromised_status"
    t.string "encryption_status"
    t.string "tpm_manufacturer"
    t.string "tpm_model_number"
    t.string "tpm_firmware"
    t.string "tpm_family"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_itam_mobile_device_securities_on_hardware_id"
  end

  create_table "memories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "caption"
    t.string "description"
    t.string "capacity"
    t.string "purpose"
    t.string "type"
    t.string "speed"
    t.integer "numslots", limit: 2
    t.string "serialnumber"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_memories_on_hardware_id"
  end

  create_table "monitors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "manufacturer"
    t.string "caption"
    t.string "description"
    t.string "type"
    t.string "serial"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_monitors_on_hardware_id"
  end

  create_table "networks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.string "type"
    t.string "typemib"
    t.string "speed"
    t.string "mtu"
    t.string "macaddr"
    t.string "status"
    t.string "ipaddress"
    t.string "ipmask"
    t.string "ipgateway"
    t.string "ipsubnet"
    t.string "ipdhcp"
    t.boolean "virtualdev"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_networks_on_hardware_id"
  end

  create_table "ports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "caption"
    t.string "description"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_ports_on_hardware_id"
  end

  create_table "printers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "driver"
    t.string "port"
    t.string "description"
    t.string "servername"
    t.string "sharename"
    t.string "resolution", limit: 50
    t.string "comment"
    t.integer "shared"
    t.integer "network"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.string "model"
    t.index ["hardware_id"], name: "index_printers_on_hardware_id"
  end

  create_table "securitycenter", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "scv"
    t.string "category"
    t.string "company"
    t.string "product"
    t.string "version"
    t.integer "enabled"
    t.integer "uptodate"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_securitycenter_on_hardware_id"
  end

  create_table "softwares", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "publisher"
    t.string "name"
    t.string "version"
    t.text "folder"
    t.text "comments"
    t.string "filename"
    t.integer "filesize"
    t.integer "source"
    t.string "guid"
    t.string "language"
    t.datetime "installdate"
    t.integer "bitswidth"
    t.text "description", size: :medium
    t.text "url"
    t.string "software_type"
    t.boolean "delta", default: true
    t.string "category"
    t.string "app_extension"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_softwares_on_hardware_id"
  end

  create_table "sounds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "manufacturer"
    t.string "name"
    t.string "description"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_sounds_on_hardware_id"
  end

  create_table "storages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "manufacturer"
    t.string "name"
    t.string "model"
    t.string "description"
    t.string "type"
    t.integer "disksize"
    t.string "serialnumber"
    t.string "firmware"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_storages_on_hardware_id"
  end

  create_table "videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "chipset"
    t.string "memory"
    t.string "resolution"
    t.bigint "hardware_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "itam_company_id", null: false
    t.index ["hardware_id"], name: "index_videos_on_hardware_id"
  end

  add_foreign_key "accountinfo", "hardware"
  add_foreign_key "api_asset_details", "hardware"
  add_foreign_key "bios", "hardware"
  add_foreign_key "bitlockerstatus", "hardware"
  add_foreign_key "controllers", "hardware"
  add_foreign_key "cpus", "hardware"
  add_foreign_key "drives", "hardware"
  add_foreign_key "inputs", "hardware"
  add_foreign_key "itam_mobile_device_securities", "hardware"
  add_foreign_key "memories", "hardware"
  add_foreign_key "monitors", "hardware"
  add_foreign_key "networks", "hardware"
  add_foreign_key "ports", "hardware"
  add_foreign_key "printers", "hardware"
  add_foreign_key "securitycenter", "hardware"
  add_foreign_key "softwares", "hardware"
  add_foreign_key "sounds", "hardware"
  add_foreign_key "storages", "hardware"
  add_foreign_key "videos", "hardware"
end
