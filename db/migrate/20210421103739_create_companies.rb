class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :api_companies do |t|
      t.string :access_token, null: false
      t.integer :itam_company_id, null: false

      t.timestamps
    end
  end
end
