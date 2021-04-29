# frozen_string_literal: true

class ItamNetworkSerializer < ActiveModel::Serializer
  attribute :ipaddress, key: :ip_address
  attribute :macaddr, key: :mac_address

end
