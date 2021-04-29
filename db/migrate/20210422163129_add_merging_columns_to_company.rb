class AddMergingColumnsToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :api_companies, :merge_it_assets_on_uuid, :boolean, default: false
    add_column :api_companies, :merge_it_assets_on_bios_serial, :boolean, default: false
    add_column :api_companies, :merge_it_assets_on_mac_address, :boolean, default: false
  end
end
