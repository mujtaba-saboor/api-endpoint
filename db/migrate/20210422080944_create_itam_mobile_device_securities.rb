class CreateItamMobileDeviceSecurities < ActiveRecord::Migration[6.0]
  def change
    create_table :itam_mobile_device_securities do |t|
      t.boolean :jailbroken
      t.boolean :encrypted
      t.boolean :supervised
      t.string :activation_lock_bypass_code
      t.string :compliance_state
      t.string :compromised_status
      t.string :encryption_status
      t.string :tpm_manufacturer
      t.string :tpm_model_number
      t.string :tpm_firmware
      t.string :tpm_family
      t.references :hardware
      t.foreign_key :hardware, column: :hardware_id, null: false

      t.timestamps
    end
  end
end
