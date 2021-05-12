# frozen_string_literal: true

# ItamNetwork contains network information
class ItamNetwork < ApplicationRecord
  self.table_name = 'networks'
  self.inheritance_column = :_type_disabled

  belongs_to :itam_hardware, foreign_key: :hardware_id

  def self.alternate_mac_address(mac_address)
    if mac_address.include?(':')
      mac_address.delete(':')
    else
      mac_address.scan(/\w{2}/).join(':')
    end
  end

  def self.alternate_mac_addresses(mac_addresses)
    mac_addresses.map { |mac_address| ItamNetwork.alternate_mac_address(mac_address) }
  end
end
