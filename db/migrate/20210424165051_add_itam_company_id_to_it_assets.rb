class AddItamCompanyIdToItAssets < ActiveRecord::Migration[6.0]
  def change
    add_column :api_asset_details, :itam_company_id, :integer, null: false
  end
end
