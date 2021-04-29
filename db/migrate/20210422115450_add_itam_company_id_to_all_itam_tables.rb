class AddItamCompanyIdToAllItamTables < ActiveRecord::Migration[6.0]
  def change
    add_column :hardware, :itam_company_id, :integer, null: false
    add_column :accountinfo, :itam_company_id, :integer, null: false
    add_column :bios, :itam_company_id, :integer, null: false
    add_column :bitlockerstatus, :itam_company_id, :integer, null: false
    add_column :controllers, :itam_company_id, :integer, null: false
    add_column :cpus, :itam_company_id, :integer, null: false
    add_column :drives, :itam_company_id, :integer, null: false
    add_column :inputs, :itam_company_id, :integer, null: false
    add_column :itam_mobile_device_securities, :itam_company_id, :integer, null: false
    add_column :memories, :itam_company_id, :integer, null: false
    add_column :monitors, :itam_company_id, :integer, null: false
    add_column :networks, :itam_company_id, :integer, null: false
    add_column :ports, :itam_company_id, :integer, null: false
    add_column :printers, :itam_company_id, :integer, null: false
    add_column :securitycenter, :itam_company_id, :integer, null: false
    add_column :softwares, :itam_company_id, :integer, null: false
    add_column :sounds, :itam_company_id, :integer, null: false
    add_column :storages, :itam_company_id, :integer, null: false
    add_column :videos, :itam_company_id, :integer, null: false
  end
end
