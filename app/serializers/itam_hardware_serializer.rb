# frozen_string_literal: true

class ItamHardwareSerializer < ActiveModel::Serializer
  attributes :id, :name, :device_type, :description, :swap
  attribute :winprodkey, key: :os_product_key
  attribute :processorn, key: :cpu_numbers
  attribute :processort, key: :cpu
  attribute :processors, key: :cpu_speed
  attribute :osversion, key: :operating_system_version
  attribute :winprodid, key: :os_product_id
  attribute :memory, key: :physical_memory
  attribute :ipaddr, key: :ip_address
  attribute :osname, key: :operating_system
  attribute :userid, key: :last_logged_in_user
  attribute :ipsrc, key: :external_ip_address
  attribute :last_synced_with_main_instance, key: :last_synced_with_assetsonar

  has_one :itam_bios, serializer: ItamBiosSerializer, key: :computer_system_and_bios
  has_many :itam_networks, serializer: ItamNetworkSerializer, key: :network_adapters
end
