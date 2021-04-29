# frozen_string_literal: true

# Comapny contains API access_token for authentication

class ApiCompany < ApplicationRecord
  has_many :itam_account_infos, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_hardwares, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_bios, foreign_key: :itam_company_id, primary_key: :itam_company_id, class_name: 'ItamBios'
  has_many :itam_bitlocker_statuses, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_controllers, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_cpus, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_drives, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_inputs, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_mobile_device_securities, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_memories, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_monitors, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_networks, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_ports, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_printers, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_security_centers, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_softwares, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_sounds, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_storages, foreign_key: :itam_company_id, primary_key: :itam_company_id
  has_many :itam_videos, foreign_key: :itam_company_id, primary_key: :itam_company_id

  has_many :api_asset_details, foreign_key: :itam_company_id, primary_key: :itam_company_id

  validates :access_token, presence: true, uniqueness: { message: 'has already been taken' }
  validates :itam_company_id, presence: true, uniqueness: { message: 'has already been taken' }

  def company_within_limit?(additional_it_assets:)
    additional_it_assets > 0
  end

end
