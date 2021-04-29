# frozen_string_literal: true

# ItamHardware contains all hardware related details
class ItamHardware < ApplicationRecord
  self.table_name = 'hardware'
  self.inheritance_column = :_type_disabled

  has_one :itam_account_info, dependent: :destroy, foreign_key: :hardware_id
  has_one :api_asset_detail, dependent: :destroy, foreign_key: :hardware_id
  has_one :itam_cpu, dependent: :destroy, foreign_key: :hardware_id
  has_one :itam_mobile_device_security, dependent: :destroy, foreign_key: :hardware_id

  has_one :itam_bios, dependent: :destroy, foreign_key: :hardware_id
  has_many :itam_bitlocker_statuses, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_controllers, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_drives, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_inputs, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_memories, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_monitors, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_networks, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_ports, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_printers, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_security_centers, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_softwares, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_sounds, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_storages, foreign_key: :hardware_id, dependent: :destroy
  has_many :itam_videos, foreign_key: :hardware_id, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100, minimum: 3 }

  def mobile_device?
    device_type == ItamSyncService::DEVICE_TYPES[:mobile_device]
  end

  def computer_device?
    device_type == ItamSyncService::DEVICE_TYPES[:computer]
  end

end
